

 //*****************************************************************************
  // Gautam Chaudhri
  // CS3B - lab1-2 - putch function
  // 1/20/2026
  //
  //putch
  //  Function putch: Provided a pointer to a char, putch will
  //  output the char on the console
  //
  //  X0: Must point to a char in memory
  //  LR: Must contain the return address (automatic when BL
  //      is used for the call)
  //  All registers except   X0, X1, X2, X8 are preserved
  //
  // Algorithm/Pseudocode:
  // 1) Prepare registers for Linux write sys_call
  // 2) Call Linux to write
  // 3) Return to location where puth function was called from
  //*****************************************************************************

  .global putch
  putch:

    .text
    MOV X1, X0          // X1 = X0
    MOV X0, #1          // 1 = stdout
    MOV X2, #1          // length of char = 1
    MOV X8, #64         // Linux write sys_call
    SVC 0               // Call Linux to write

    RET

.end
