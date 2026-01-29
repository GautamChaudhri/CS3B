  //*****************************************************************************
  // Gautam Chaudhri
  // CS3B - lab3-1 - 123 ABC GDB
  // 1/27/2026
  //
  // Algorithm/Pseudocode:
  // 1) Store addresses for all three variables into registers X0-X2.
  // 2) Store value for i32X variable in X3.
  // 3) Prepare registers for Linux termination.
  // 4) Call Linux to terminate.
  //*****************************************************************************


.global _start 
_start:

    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call


    .text

    // Move data into registers as required by assignment
    LDR X0, =szMsg1     // move address stored in szMsg1 into X0
    LDR X1, =szMsg2     // move address stored in szMsg2 into X1
    LDR X2, =i32X       // move address stored in i32X into X2
    LDR X3, [X2]        // move value stored in i32X into X3

    // Prepare to terminate
    MOV X0, #0          // use 0 for return code success
    MOV X8, #SYS_exit   // service code to exit
    SVC 0               // call linux to exit    

    .data
    szMsg1: .asciz "Oh that things could be\n"
    szMsg2: .asciz "as they once were."
    i32X:   .word 0x1234ABCD

.end
