  //*****************************************************************************
  // Gautam Chaudhri
  // 2/5/2026
  //
  // Algorithm/Pseudocode:
  // while loop practice
  // Topic 3: while loop
  //*****************************************************************************

.global _start
_start:
    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call

    .text
    MOV W5, #3

    loop: 
    B.

    endloop:

    // Prepare to terminate
    MOV X0, #0          // use 0 for return code success
    MOV X8, #SYS_exit   // service code to exit
    SVC 0               // call linux to exit 

    .data
