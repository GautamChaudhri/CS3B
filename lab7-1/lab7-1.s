//*****************************************************************************
// Gautam Chaudhri
// Mar 12, 2026
// lab7-1 - puddy tat
//
// Algorithm/Pseudocode:
// 1)
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



  .text
  // Get first filename
  LDR X0, =filePrompt_1   // load first file prompt
  BL putstring            // output prompt to console
  LDR X0, =filenameBuf    // load filename buffer for getstring
  MOV X1, #FILENAME_BUFFER_SIZE  // load size of buffer
  BL getstring            // use getstring to get filename
  STR X4, [X0]            // save filename

  // Get second filename
  LDR X0, =filePrompt_2   // load second file prompt
  BL putstring            // output prompt to console
  LDR X0, =filenameBuf    // load filename buffer for getstring
  MOV X1, #FILENAME_BUFFER_SIZE  // load size of buffer
  BL getstring            // use getstring to get filename
  STR X5, [X0]            // save filename

  // Get output filename
  LDR X0, =outFilePrompt  // load output file prompt
  BL putstring            // output prompt to console
  LDR X0, =filenameBuf    // load filename buffer for getstring
  MOV X1, #FILENAME_BUFFER_SIZE  // load size of buffer
  BL getstring            // use getstring to get filename
  STR X6, [X0]            // save filename

  // Get append choice
  LDR X0, =outFilePrompt  // load append prompt
  BL putstring            // output prompt to console
  LDR X0, =filenameBuf    // load filename buffer for getstring
  MOV X1, #FILENAME_BUFFER_SIZE  // load size of buffer
  BL getstring            // use getstring to get append choice
  STR X7, [X0]            // save append choice

  // Prepare to terminate
terminate:
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call linux to exit 


  .data
// Buffers
filenameBuf:    .skip     FILENAME_BUFFER_SIZE
copyBuf:        .skip     COPY_BUF_SIZE

// Prompts
filePrompt_1:   .asciz    "Enter first input file name : "
filePrompt_2:   .asciz    "Enter second input file name: "
outFilePrompt:  .asciz    "Enter output file name      : "
appendPrompt:   .asciz    "Append to the output? [y/N] : "
fatalError:     .asciz    "Fatal error: failed to open input file "

// Macros
.macro GET_PROMPT_INPUT prompt, dest_reg
  LDR X0, =\prompt                // prompt to output
  BL putstring                    // output prompt to console
  LDR X0, =filenameBuf            // load filename buffer for getstring
  MOV X1, #FILENAME_BUFFER_SIZE   // load size of buffer
  BL getstring                    // use getstring to get input
  STR X4, [\dest_reg]             // save input
.endm