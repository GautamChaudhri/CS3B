//*****************************************************************************
// Gautam Chaudhri
// Mar 12, 2026
// lab7-1 - puddy tat
// Copies two input files to an output file.
//
// Algorithm/Pseudocode:
// 1) Accept input file names and immediately open each one. Save their file
//    descriptor values to registers so no need to keep track of names.
//      * if error occurs when opening then handle it
// 2) Accept output file name and append choice. 
// 3) Evaluate append choice, then start accumlating appropriate flags based
//    on user choice. 
// 4) Open output file with appropriate flags. Save file descriptor so file
//    name is no longer needed.
//      * handle errors if they occur
// 5) In a loop, repeatedly read from input file and write to output file.
//    Stop looping when number of characters read < copy buffer size. 
//    Repeat this step for second input file as well.
// 6) Close all 3 files then terminate.
//*****************************************************************************

.global _start
_start:
  // Standard Aliases
  .EQU STDIN, 0         // STDIN
  .EQU STDOUT, 1        // STDOUT
  .EQU STDERR, 2        // STDERR
  .EQU SYS_read, 63     // read() system call
  .EQU SYS_write, 64    // write() system call
  .EQU SYS_exit, 93     // exit() system call

  // File Operation Aliases
  .EQU AT_FDCWD, -100   // filename relevant to current directory
  .EQU O_RDONLY, 0      // read only mode
  .EQU O_WRONLY, 1      // write only mode
  .EQU O_CREAT, 0100    // create file if nonexistent
  .EQU O_EXCL, 0200     // exclusive create, fail if file already exists
  .EQU O_TRUNC, 01000   // truncate existing file
  .EQU O_APPEND, 02000  // append to existing file
  .EQU O_RDWR, 0666     // file permissions, read/write global
  .EQU SYS_openat, 56   // Linux openat()
  .EQU SYS_close, 57    // Linux close()

  .EQU FILENAME_BUFFER_SIZE, 64   // size of filename buffer
  .EQU COPY_BUF_SIZE, 16          // size of copy buffer size


// Macros
.macro GET_PROMPT_INPUT prompt, filenameBuf
  LDR X0, =\prompt                // prompt to output
  BL putstring                    // output prompt to console
  LDR X0, =\filenameBuf           // load filename buffer for getstring
  MOV X1, #FILENAME_BUFFER_SIZE   // load size of buffer
  BL getstring                    // use getstring to get input
.endm

.macro OPEN_FILE filenameBuf, flags_reg, fd_reg, errorLabel
  MOV X0, #AT_FDCWD               // file in current word directory
  LDR X1, =\filenameBuf           // load file name
  MOV X2, \flags_reg              // open file read only
  MOV X3, #O_RDWR                 // file permissions, global read/write
  MOV X8, #SYS_openat             // service code to open file
  SVC 0                           // call OS to open file
  CMP X0, XZR                     // check returned file descriptor value
  B.LT \errorLabel                // IF fd is negative, then file failed to open, deal with it
  MOV \fd_reg, X0                 // ELSE save returned fd value
.endm

.macro CLOSE_FILE file_fd 
  MOV X0, \file_fd                // fd of file to close
  MOV X8, #SYS_close              // service code to close file
  SVC 0                           // call OS to close
.endm

.macro COPY_FILE inFile_fd, outFile_fd
copyLoop_\@:              // \@ = macro counter, used by GAS to generate unique labels
  MOV X0, \inFile_fd      // load input file fd
  LDR X1, =bCopyBuf       // load copy buffer to hold data
  MOV X2, #COPY_BUF_SIZE  // max bytes to read
  MOV X8, #SYS_read       // service code for read
  SVC 0                   // call OS to read

  MOV X7, X0              // save number of char read

  MOV X0, \outFile_fd     // load output file fd
  LDR X1, =bCopyBuf       // load copy buffer to hold data
  MOV X2, X7              // max bytes to write = number of char read
  MOV X8, #SYS_write      // service code for write
  SVC 0                   // call OS to read
  
  CMP X7, #COPY_BUF_SIZE  // compare number of char read to read size
  B.EQ copyLoop_\@        // IF number of char == read size, then reloop
.endm

.macro OUTPUT_ERROR errorPrompt, filenameBuf
  LDR X0, =\errorPrompt             // load error prompt
  BL putstring                      // output error prompt
  LDR X0, =\filenameBuf             // load file name
  BL putstring                      // output file name
  LDR X0, =szEOL                    // load \n
  BL putstring                      // output \n
.endm


  .text
  // Get input file names and save their fd
  MOV X2, #O_RDONLY                                  // load flags into X2
  GET_PROMPT_INPUT szFilePrompt_1, szInFilenameBuf   // get input file 1 name
  OPEN_FILE szInFilenameBuf, X2, X4, inputFileError  // open file and save fd to X4 if it exists
  GET_PROMPT_INPUT szFilePrompt_2, szInFilenameBuf   // get input file 2 name
  OPEN_FILE szInFilenameBuf, X2, X5, inputFileError  // open file and save fd to X5 if it exists

  // Get output file name and append choice
  GET_PROMPT_INPUT szOutFilePrompt, szOutFilenameBuf  // get output file name
  GET_PROMPT_INPUT szAppendPrompt, szInFilenameBuf    // get append choice, store in InFilenameBuf

  // Evaluate append choice
  LDRB W0, [X0]       // extract append choice from buffer
  MOV X1, #'Y'        // load y ascii value
  CMP X0, X1          // compare append choice to 'Y'
  B.EQ appendMode     // IF append choice == 'Y', then branch
  MOV X2, #O_TRUNC    // ELSE load X2, with truncate flag
  B next              // jump around loading append flag

appendMode:
  MOV X2, #O_APPEND   // load X2 with append flag

next: 
  // Prepare flags and open output file
  ADD X2, X2, #O_WRONLY   // add write only flag
  ADD X2, X2, #O_CREAT    // add create file flag
  OPEN_FILE szOutFilenameBuf, X2, X6, outputFileError  // open output file and save fd to X6

  // Copy input files to output file
  COPY_FILE X4, X6      // copy first input file to output file
  COPY_FILE X5, X6      // copy second input file to output file

  // Prepare to terminate
terminate:
  CLOSE_FILE X4       // close first input file
  CLOSE_FILE X5       // close second input file
  CLOSE_FILE X6       // close output file
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call OS to exit 

inputFileError:
  OUTPUT_ERROR szInFileError, szInFilenameBuf     // display input file error
  B terminate                                     // jump to terminate

outputFileError:
  OUTPUT_ERROR szOutFileError, szOutFilenameBuf   // display output file error
  B terminate                                     // jump to terminate


  .data
// Buffers
szInFilenameBuf:  .skip     FILENAME_BUFFER_SIZE
szOutFilenameBuf: .skip     FILENAME_BUFFER_SIZE
bCopyBuf:        .skip     COPY_BUF_SIZE

// Prompts
szFilePrompt_1:   .asciz    "Enter first input file name : "
szFilePrompt_2:   .asciz    "Enter second input file name: "
szOutFilePrompt:  .asciz    "Enter output file name      : "
szAppendPrompt:   .asciz    "Append to the output? [Y/N] : "
szInFileError:    .asciz    "Fatal Error: failed to open input file "
szOutFileError:   .asciz    "Fatal Error: failed to open output file "
szEOL:            .asciz    "\n"
