  //*****************************************************************************
  // Gautam Chaudhri
  // CS3B - lab4-1 - String_length and putstring functions
  // 1/27/2026
  //
  //String_length
  //  Function String_length: Provided a pointer to a null terminated string in
  //  X0, will return the string's length in X0
  //
  //  X0: Must point to a null terminated string
  //  LR: Must contain the return address (automatic when BL
  //      is used for the call)
  //  All registers except   X0, X1, and X2 are preserved
  //
  // Algorithm/Pseudocode:
  // 1)
  //*****************************************************************************
String_length:
    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call

    .text
    // Set up registers for loop controls
    MOV X1, #0          // index for stepping through string

    // Step through and examine
    loop_start:
    LDRB W2, [X0, X1]   // load character at givenString[baseIndex + index]
    B.EQ termination    // if character in W2 is null-terminator, then jump to termination
    ADD X1, X1, #1      // if here then character is not null-terminator, so index++
    B loop_start        // and then reloop to exmaine next character


    termination:
    // First setup X0 with correct return value for string length
    ADD X0, X1, #1      // add one to index to get string length and store in correct register
    RET                 // return back to location where this function was called  

    .data

.end
