  //*****************************************************************************
  // Gautam Chaudhri
  // 2/3/2026
  //
  // Algorithm/Pseudocode:
  // Learning branching.
  // Topic 3: Basic GDB using ADD(S), B.EQ
  //*****************************************************************************

.global _start
_start:
    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call

    .text
    MOV X0, #-1
    MOV X1, #1
    ADD X2, X0, X1
    B.EQ check
    NOP

check:
    // Prepare to terminate
    MOV X0, #0          // use 0 for return code success
    MOV X8, #SYS_exit   // service code to exit
    SVC 0               // call linux to exit 

    .data
szCourse: .asciz "XS3B"
