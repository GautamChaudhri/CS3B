  //*****************************************************************************
  // Gautam Chaudhri
  // CS3B - lab4-1 - String_length and putstring functions
  // 1/27/2026
  //
  //putstring
  //  Function putstring: Provided a pointer to a null terminated string in
  //  X0, will output the string on the console
  //
  //  X0: Must point to a null terminated string
  //  LR: Must contain the return address (automatic when BL
  //      is used for the call)
  //  All registers except   X0, X1, X2, X3, and X8 are preserved
  // 
  // Algorithm/Pseudocode:
  // 1)
  //*****************************************************************************
putstring:
    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call

    .text
    // Prepare for String_length function call to get length
    MOV X3, X0          // copy string pointer to X3 since X0 will be overwritten by String_length
    BL String_length    // call function to get string length

    // Prepare registers for Linux write function call
    MOV X2, X0          // put string length in X2 for write function
    MOV X1, X3          // put string pointer in X1 for write function
    MOV X0, #STDOUT     // set X0 register so write function prints to STDOUT
    SVC 0               // call linux to print to console

    // Prepare for termination
    RET 
    
    .data
.end
