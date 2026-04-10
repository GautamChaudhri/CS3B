//*****************************************************************************
// Gautam Chaudhri
// Apr 7, 2026
// Topic 6 - Basic Floating Point stuff Practice
//
// Algorithm/Pseudocode:
// 1)
//*****************************************************************************

.global _start
_start:
  /// Standard Aliases
  .EQU STDIN, 0       // STDIN
  .EQU STDOUT, 1      // STDOUT
  .EQU STDERR, 2      // STDERR
  .EQU SYS_read, 63   // read() system call
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  .text
  LDR X0, =length   // load length buffer
  LDR S0, [X0]      // load length value
  LDR X1, =width
  LDR S1, [X1]

  FMOV S5, #2.0
  FMUL S2, S0, S1   // area = length * width
  FMUL S3, S0, S5   // load length * 2
  FMUL S4, S1, S5   // load width * 2
  FADD S3, S3, S4   // perimeter = length * 2 + width * 2

  FCVT D4, S3       // convert perimeter from single to double
  LDR X8, =hold     // load variable
  STR D4, [X8]      // store in memory

  // Prepare to terminate
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call linux to exit 

  .data
length:   .single   12.5
width:    .single   8.0
dArea:    .single   0
dPer:     .single   0
hold:     .double   
