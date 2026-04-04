//*****************************************************************************
// Gautam Chaudhri
// Mar 26, 2026
// lab7-2 - driver
//
// Algorithm/Pseudocode:
// 1) Open input file
// 2) In a loop, call getline with correct parameters and output its result
//    to console via putstring.
// 3) Exit loop when getline returns 0 characters read
//*****************************************************************************

.global _start
_start:
  .include "macros.s" // include custom made macros

  // Standard Aliases
  .EQU STDIN, 0       // STDIN
  .EQU STDOUT, 1      // STDOUT
  .EQU STDERR, 2      // STDERR
  .EQU SYS_read, 63   // read() system call
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  // File Operation Aliases
  .EQU AT_FDCWD, -100 // filename relevant to current directory
  .EQU O_RDONLY, 0    // read only mode
  .EQU O_WRONLY, 1    // write only mode
  .EQU O_CREAT, 0100  // create file if nonexistent
  .EQU O_EXCL, 0200   // exclusive create, fail if file already exists
  .EQU O_RDWR, 0666   // file permissions, read/write global
  .EQU SYS_openat, 56 // Linux openat()
  .EQU SYS_close, 57  // Linux close()

  // Driver7-2 aliases
  .EQU bufferSize, 65 // size of buffer

  .text
  // Open file
  MOV X7, #O_RDONLY       // load read only access
  MOV X8, #O_RDWR         // load file permissions
  OPEN_FILE szReadFile,X7, X8, X5, openFileError   // open file to read from

fileLoop:
  // Call getline
  MOV X0, X5              // load fd
  LDR X1, =szBuffer       // buffer written to by getline
  MOV X2, #bufferSize     // max read size
  BL getline              // call getline 

  // Print getline result
  MOV X7, X0              // save number of characters read by getline
  PRINT szBuffer          // print getline result to console
  PRINT_EOL               // print \n

  CBNZ X7, fileLoop       // IF number of characters read != 0, then reloop

terminate:
  // Prepare to terminate
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call linux to exit 

openFileError:
  OUTPUT_FILE_ERROR szOpenFileError, szReadFile   // output error
  B terminate                                     // jump to terminate

  .data
szBuffer:        .skip    bufferSize              // buffer
szReadFile:      .asciz   "Lab7-2InputFile.txt"   // name of file to read
szOpenFileError: .asciz   "Fatal error: failed to open input file "
