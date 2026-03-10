//*****************************************************************************
// Gautam Chaudhri
// Mar 3, 2026
// lab6-1 - getstring function 
//*****************************************************************************
//getstring
//  Function getstring: Will read a string of characters up to a specified length
//  from the console and save it in a specified buffer as a C-String (i.e. null
//  terminated).
//  
//  X0: Points to the first byte of the buffer to receive the string. This must
//      be preserved (i.e. X0 should still point to the buffer when this function
//      returns).
//  X1: The maximum length of the buffer pointed to by X0 (note this length
//      should account for the null termination of the read string (i.e. C-String)
//  LR: Must contain the return address (automatic when BL
//      is used for the call)
//  All AAPCS mandated registers are preserved.
//*****************************************************************************
// Algorithm/Pseudocode:
// 1)
//*****************************************************************************

.global _start
_start:
  .EQU STDIN, 0      // STDIN
  .EQU STDOUT, 1      // STDOUT
  .EQU SYS_read, 63  // read() system call
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  .EQU MAX_BYTES, 10  // max bytes to read()

  .text
  // Read from STDIN
  MOV X0, #STDIN         // file descriptor
  LDR X1, =szBuffer     // buffer for read()
  MOV X2, #MAX_BYTES     // max bytes to read from STDIN
  MOV X8, #SYS_read      // read() system call
  SVC 0                 // call Linux to read string

  // Add null terminator to string
  LDR X1, =szBuffer     // get base address for string
  ADD X1, X1, 10        // move pointer to end of string
  MOV X2, #0         // get null terminator
  STRB W2, [X1]         // place null terminator at end of string

  // Output preamble to STDOUT
  MOV X0, #STDOUT        // file descriptor
  LDR X1, =szPreamble   // address of preamble string
  MOV X2, #13           // length of preamble
  MOV X8, #SYS_write     // read() system call
  SVC 0                 // call Linux to output string

  // Output buffer to STDOUT
  MOV X0, #STDOUT        // file descriptor
  LDR X1, =szBuffer   // address of preamble string
  MOV X2, #11           // length of buffer
  MOV X8, #SYS_write     // read() system call
  SVC 0                 // call Linux to output string

  // Prepare to terminate
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call linux to exit 

  .data
szBuffer: .skip 11
szPreamble: .ascii "You entered: "
