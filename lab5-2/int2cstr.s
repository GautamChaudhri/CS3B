  //*****************************************************************************
  // Gautam Chaudhri
  // 2/12/2026
  // Lab 5-2 | int2cstr function
  //*****************************************************************************
  // Function int2cstr: Provided a signed integer, will convert it to a C-String 
  //                    stored stored in memory pointed to by a provided pointer
  //                    that must be large enough to hold the converted value. 
  //                    Usually a string of 21 bytes is more than sufficient to allow  
  //                    for a sign as well as the largest possible value a word could be.
  //
  // X0: Contains the binary (signed) value to be converted to a C-String
  // X1: Must point to address large enough to hold the converted value.
  // LR: Contains the return address (automatic when BL is used)
  // Registers X0 - X8 are modified and not preserved
  //*****************************************************************************
  // Algorithm/Pseudocode: negative loop
  // 0) Divide integer by 10 in a loop repeatedly until it becomes 0. Take the 
  //    amount of loops and add 2 if negative or 1 if positive. This becomes the length 
  //    of our c-string.
  // 1) Divide integer by 10. 
  // 2) Recreate remainder by finding difference between integer and the quotient * 10
  // 3) Add 48 to remainder to get ascii and store in array. Overwrite integer with quotient.
  // 4) Repeat steps 1-2 in a loop until integer becomes 0.
  // 5) Set up two pointers, pointing to the first and last elements of the remainder
  //    array.
  // 6) Swap first and last elements and march pointers towards each other until
  //    everything is swapped.
  //*****************************************************************************

.global int2cstr
int2cstr:
  .EQU STDOUT, 1      // STDOUT
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  .text
  // Find length of c-string
  MOV X2, #1            // will hold length of c-string, starts at 1 to count null-terminator
  MOV X3, X0            // copy integer value so we dont lose the original
  MOV X4, #10           // X4 = divisor = 10
  
  calcLength:
  SDIV X3, X3, X4       // integerCopy /= 10
  ADD X2, X2, #1        // length++
  CBNZ X3, calcLength   // re loop if integerCopy != 0

  CMP X0, #0            // check if givenInteger is negative
  B.PL extraction       // IF givenInteger < 0
  ADD X2, X2, #1        // THEN length++ to count for - sign
  MOV X7, #45           // Load X7 with ascii for -
  STRB W7, [X1, X2]     // array[lastIndex] = '-'


  // Extract each integer and store in array
  extraction:
  MOV X3, X0            // copy integer value so we dont lose the original
  MOV X8, #1            // tracks index for remainder array, starting at 1 to skip null terminator
  MOV X7, #0            // store null terminator in X7
  STRB W7, [X1]         // array[0] = '\0'

  extractLoop:
  SDIV X5, X3, X4       // quotient = integerCopy / 10
  MUL X6, X5, X4        // X6 = quotient * 10
  SUB X7, X3, X6        // remainder (X7) = givenInteger - X6

  ADD X7, X7, #48       // convert remainder into its corresponding ascii value
  STRB W7, [X1, X8]     // array[baseIndex + index] = remainder in ascii
  ADD X8, X8, #1        // index++

  MOV X3, X5            // move quotient back in to X3 so we can continue
  CBNZ X3, extractLoop  // re loop if quotient != 0


  // Setup start and end pointers
  MOV X5, X1            // start pointer pointing at array[0]
  ADD X8, X1, X2        // pointer to array[length], *this is one past the last valid index*
  SUB X8, X8, #1        // end pointer pointing at array[lastValidIndex]

  swapLoop:
  LDRB W6, [X5]         // load character from beginning of array
  LDRB W7, [X8]         // load character from end of array
  STRB W6, [X8]         // array[end] = character from start of array
  STRB W7, [X5]         // array[start] = character from end of array

  ADD X5, X5, #1        // startPointer++
  SUB X8, X8, #1        // endPointer--
  CMP X5, X8            // compare start and end pointers
  B.LT swapLoop         // IF X5 < X8 then reloop

  RET                   // jump back to function call

  .data
