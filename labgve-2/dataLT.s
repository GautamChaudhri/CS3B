//*****************************************************************************
// Gautam Chaudhri
// May 1, 2026
// labgve-2 Link Me - dataLT function
//
// Algorithm/Pseudocode:
// 1) Set lessThan flag to false (0) by default
// 2) Compare data1 and data2, if data1 < data2, set flag to true (1), otherwise
//    leave it unchanged
// 3) Return
//*****************************************************************************

.global dataLT
dataLT:
  /// Standard Aliases
  .EQU STDIN, 0       // STDIN
  .EQU STDOUT, 1      // STDOUT
  .EQU STDERR, 2      // STDERR
  .EQU SYS_read, 63   // read() system call
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  .text
  MOV X2, XZR         // set less than flag to false (0)
  CMP X0, X1          // compare data1 and data2
  B.GE return         // IF data1 >= data2, then leave flag as false
  MOV X2, #1          // ELSE data1 < data2, set flag to true

return:
  MOV X0, X2          // move less than flag to X0
  RET                 // return

  .data
