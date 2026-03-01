//*****************************************************************************
// Gautam Chaudhri
// Feb 19, 2026
// lab5-3 - cstr2int function
//*****************************************************************************
// Function cstr2int: Provided a pointer to a C-String representing a valid 
//                    signed integer, converts it to a quad integer. 
//                    If under/overflow occurs, then the overflow flag must be set
//                    and a value of 0 returned.
//
// X0: Must point to a null terminated string that is a valid signed 64 bit decimal number
// X0: signed quad result
// LR: Contains the return address (automatic when BL is used)
// Registers X0 - X8 are modified and not preserved
//*****************************************************************************
// Algorithm/Pseudocode: negative loop
// 1) Check if cstring contains negative value and set flag accordingly
// 2) Loop through cstring and grab each character, convert to negative integer
// 3) Check MUL overflow manually | deal with overflow if threshold < accumulator 
// 4) Update accumulator using ADDS to check for ADD overflow and deal with it if necessary
// 5) After loop, negate result if necessary based on eariler flag
//    * Use NEGS to check for NEG overflow and deal with it if necessary
// 6) Return
//*****************************************************************************

.global cstr2int
cstr2int:
  .EQU STDOUT, 1      // STDOUT
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  .text
  // Initial Setup
  MOV X1, #0                        // accumulator = 0
  LDR X7, =dwMulOverflowThreshold   // X7 = variable address
  LDR X8, [X7]                      // set up value to compare against to check mult overflow
  MOV X6, #10                       // load imm value 10 for use with MUL later

  // Check if cstring contains negative number and set flag accordingly
  MOV X7, #0            // X7 = flag for if integer is negative or positive. 0 = pos, 1 = neg
  LDRB W2, [X0]         // grab first char
  CMP X2, #'-'          // compare char with '-'
  B.NE loop             // IF W2 == '-'
  MOV X7, #1            // THEN given integer is negative so set flag
  ADD X0, X0, #1        // also advance pointer so the loop grabs the first char integer and not '-'

loop:
  // Grab char and exit if null
  LDRB W2, [X0], #1   // W2 = cstring[index++], grabbing character
  CBZ X2, loopExit    // if char == null terminator, then exit loop

  // Convert char to negative integer
  SUB X2, X2, #'0'     // convert char into its integer value
  NEG X2, X2          // negate b/c we are using negative loop

  // Check MUL overflow
  CMP X8, X1          // compare MulOverflowThreshold with current accumulator
  B.GT overflow       // IF MulOverflowThreshold < current accumlator then deal with overflow

  // Update accumlator
  MUL X1, X1, X6      // accumulator *= 10
  ADDS X1, X1, X2     // accumulator += current integer
  B.VS overflow       // IF overflow occurred when adding then deal with it
  B loop              // ELSE reloop

loopExit:
  // Check negative flag
  CBNZ X7, termination    // IF X7 flag indicates positive value (0)
  NEGS X1, X1             // THEN negate accumulator so it becomes positive
  B.VS overflow           // IF overflow occurred when negating then deal with it

termination:
  MOV X0, X1              // move result into X0
  RET                     // return to calling function

overflow:
  MOV X1, #0              // replace return value with 0

  // Manually set overflow flag
  MOV X3, #-1             // register = 111.....111
  MOV X4, X3, LSR #1      // register = 011.....111
  ADDS X5, X4, X4         // this will result in overflow flag being set
  B termination           // branch to termination

  .data
dwMulOverflowThreshold: .quad -922337203685477580   // (most negative 64-bit value) / 10
