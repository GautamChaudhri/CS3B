  //*****************************************************************************
  // Gautam Chaudhri
  // 2/5/2026
  // 
  //
  // Algorithm/Pseudocode:
  // Two-sided Selection - learning if statements
  // Topic 3: GDB Selection 
  //*****************************************************************************

.global _start
_start:
    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call

    .text
    MOV W5, #11

    CMP W5, #10         // if W5 < 10
    B.GE else           
    NOP                 // true clause
    B endif             // jump around else

    else:               // false clause
    NOP

    endif:              // end if statement
    NOP

    // Prepare to terminate
    MOV X0, #0          // use 0 for return code success
    MOV X8, #SYS_exit   // service code to exit
    SVC 0               // call linux to exit 

    .data


