  //*****************************************************************************
  // Gautam Chaudhri
  // 1/29/2026
  //
  // Algorithm/Pseudocode:
  // Learning load store and STRB
  // Topic 2: Basic GDB using STR(B)/LDR(B)
  //*****************************************************************************

.global _start
_start:
    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call

    .text
    LDR X0, =szCourse           // load label address into register
    LDRB W1, [X0]                 // load first byte of label into register
    MOV W2, #'C'                // load literal C into register
    STRB W2, [X0]
    
    // Prepare to terminate
    MOV X0, #0          // use 0 for return code success
    MOV X8, #SYS_exit   // service code to exit
    SVC 0               // call linux to exit 

    .data
szCourse: .asciz "XS3B"
