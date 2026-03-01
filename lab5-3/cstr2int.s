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
// Algorithm/Pseudocode:
// 1) Loop through cstring, grabbing each character and converting to its integer value
// 2) Multiply accumulator by 10 and add new integer value
//*****************************************************************************

.global cstr2int
cstr2int:
  .EQU STDOUT, 1      // STDOUT
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  .text
  // Initial Setup
  MOV X1, #0                    // set up accumulator
  LDR X7, =overflowThreshold
  LDR X8, [X7]   // set up value to compare against to check mult overflow

  // Check if cstring contains negative number and set flag accordingly
  MOV X7, #0            // X7 = flag for if integer is negative or positive. 0 = pos, 1 = neg
  LDRB W2, [X0]         // grab first char
  CMP X2, #'-'          // compare char with '-'
  B.NE loop             // IF W2 == '-'
  MOV X7, #1            // THEN given integer is negative so set flag
  ADD X0, X0, #1        // also advance pointer so the loop grabs the first integer char and not '-'

loop:
  // Grab char and exit when it is null
  LDRB W2, [X0], #1   // W2 = cstring[index++], grab chars
  CBZ X2, loopExit    // if char == null terminator, then exit loop

  // Convert char to negative integer
  SUB X2, X2, #48     // convert char into its integer value
  NEG X2, X2          // negate b/c we are using negative loop

  // Check MUL overflow
  CMP X8, X1          // compare overflowThreshold with current accumulator
  B.GE mulOverflow    // IF overflowThreshold < current accumlator THEN overflow will happen

  // Update accumlator
  MOV X6, #10         // load imm value 10
  MUL X1, X1, X6      // accumulator *= 10
  ADD X1, X1, X2      // accumulator += current integer
  B loop              // reloop

loopExit:
  // Check negative flag
  CBNZ X7, termination  // IF X7 flag indicates positive value (0)
  NEG X1, X1            // THEN negate accumulator so it becomes positive

termination:
  // Move result into X0 and return
  MOV X0, X1
  RET

mulOverflow:
  // Replace result with 0
  MOV X1, #0

  // Manually set overflow flag
  MOV X3, #-1
  MOV X4, X3, LSR #1
  ADD X5, X4, X4
  B termination

  .data
overflowThreshold: .quad -922337203685477580 // equal to most negative value / 10
