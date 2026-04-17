//*****************************************************************************
// Gautam Chaudhri
// Feb 19, 2026
// lab5-3 - cstr2int function (modified: no overflow handling)
//*****************************************************************************
// Function cstr2int: Provided a pointer to a C-String representing a valid 
//                    signed integer, converts it to a quad integer. 
//                    On overflow, silently wraps (returns garbage) rather than
//                    returning 0 with the overflow flag set.
//
// X0: Must point to a null terminated string that is a valid signed decimal number
// X0: signed quad result (undefined value on overflow)
// LR: Contains the return address (automatic when BL is used)
// Registers X0 - X8 are modified and not preserved
//*****************************************************************************
// Algorithm/Pseudocode: negative loop
// 1) Check if cstring contains negative value and set flag accordingly
// 2) Loop through cstring and grab each character, convert to negative integer
// 3) Update accumulator (no overflow checks)
// 4) After loop, negate result if necessary based on earlier flag
// 5) Return
//*****************************************************************************

.global cstr2int
cstr2int:

  .text
  // Initial Setup
  MOV X1, #0            // accumulator = 0
  MOV X6, #10           // load imm value 10 for use with MUL later

  // Check if cstring contains negative number and set flag accordingly
  MOV X7, #0            // X7 = flag for if integer is negative or positive. 0 = pos, 1 = neg
  LDRB W2, [X0]         // grab first char
  CMP X2, #'-'          // compare char with '-'
  B.NE loop             // IF W2 == '-'
  MOV X7, #1            // THEN given integer is negative so set flag
  ADD X0, X0, #1        // also advance pointer so the loop grabs the first char integer and not '-'

loop:
  // Grab char and exit if null
  LDRB W2, [X0], #1     // W2 = cstring[index++], grabbing character
  CBZ X2, loopExit      // if char == null terminator, then exit loop

  // Convert char to negative integer
  SUB X2, X2, #'0'      // convert char into its integer value
  NEG X2, X2            // negate b/c we are using negative loop

  // Update accumulator (no overflow check)
  MUL X1, X1, X6        // accumulator *= 10
  ADD X1, X1, X2        // accumulator += current integer
  B loop                // reloop

loopExit:
  // Check negative flag
  CBNZ X7, termination  // IF X7 flag indicates negative value, skip negation
  NEG X1, X1            // ELSE negate accumulator to make it positive

termination:
  MOV X0, X1            // move result into X0
  RET                   // return to calling function

  .data
