//*****************************************************************************
// Gautam Chaudhri
// March 5, 2026
// lab6-3 - driver
//
// Creates a buffer and calls getstring with appropriate parameters. Then outputs
// the result from getstring to console using putstring.
//*****************************************************************************

.global _start
_start:
  .EQU STDIN, 0       // STDIN
  .EQU STDOUT, 1      // STDOUT
  .EQU SYS_read, 63   // read() system call
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  .EQU BUFFER_SIZE, 10 // size of buffer

  .text
  LDR X0, =szBuffer         // load buffer location as parameter
  MOV X1, #BUFFER_SIZE      // size of buffer
  BL getstring              // call getstring
  BL putstring              // output result to console
  LDR X0, =szEOL            // load new line character
  BL putstring              // output new line

  // terminate
  MOV X0, #0                // set return code to 0 (success)
  MOV X8, #SYS_exit         // load syscall number for exit()
  SVC 0                     // call Linux to terminate the program

  .data
szBuffer: .skip BUFFER_SIZE
szEOL:       .asciz "\n"  // newline string for output formatting

