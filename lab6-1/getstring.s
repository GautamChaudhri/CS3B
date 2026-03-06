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
// 1) Save parameters to different registers to prevent overwrites from SYS calls
//      * subtract 1 from buffer size to get read size and save that instead
// 2) Read value from STDIN
// 3) Analyze last read character and compare to \n
//      * IF char == \n, then replace with null terminator
//      * ELSE place null terminator at least read char + 1
// 4) Return
//*****************************************************************************

.global getstring
getstring:
  .EQU STDIN, 0       // STDIN
  .EQU STDOUT, 1      // STDOUT
  .EQU SYS_read, 63   // read() system call
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  .text
  // Save parameters so they are not overwritten
  MOV X6, X0            // save buffer location in X6
  SUB X7, X1, #1        // save read size = buffer size -1

  // Read from STDIN
  MOV X0, #STDIN        // file descriptor
  MOV X1, X6            // buffer location for read()
  MOV X2, X7            // max bytes to read from STDIN
  MOV X8, #SYS_read     // read() system call
  SVC 0                 // call Linux to read string

  // Analyze last character and write null terminator
  ADD X0, X6, X0        // bufferStart + number of characters read
  SUB X0, X0, #1        // pointer to last read character
  LDRB W1, [X0]         // get last read character
  MOV X2, #10           // load '\n'
  CMP X1, X2            // compare last char with \n
  B.EQ writeNull        // IF last read char != '\n'
  ADD X0, X0, #1        // THEN pointer++
writeNull:
  STRB WZR, [X0]        // write null terminator to buffer

  // Return
  MOV X0, X6            // move buffer location back into X0
  RET                   // return

  .data
