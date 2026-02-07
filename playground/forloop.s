  //*****************************************************************************
  // Gautam Chaudhri
  // 2/5/2026
  //
  // Algorithm/Pseudocode:
  // Practice for loop
  // Topic 3: for loop
  //*****************************************************************************

.global _start
_start:
    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call

    .text
    MOV W2, #3          // counter

    CMP W2, #3          // initial condition check before loop start
    loop:
    B.EQ endloop        // for loop condition check

    NOP
    SUBS W2, W2, #1     // update counter with flags
    B loop              // reloop

    endloop:
    NOP    


    // Prepare to terminate
    MOV X0, #0          // use 0 for return code success
    MOV X8, #SYS_exit   // service code to exit
    SVC 0               // call linux to exit 

    .data
