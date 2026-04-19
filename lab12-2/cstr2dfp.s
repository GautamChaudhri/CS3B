//*****************************************************************************
// Gautam Chaudhri
// Apr 15, 2026
// lab12-2 - cstr2dfp
//*****************************************************************************
// Function cstr2dfp: Provided a pointer to a C-String representing a valid 
//                    floating point number, converts it to a double floating
//                    point value. 
//
// X0: Must point to a null terminated string that is a valid signed floating
//     point number.
// D0: signed double floating point result
// LR: Contains the return address (automatic when BL is used)
// Registers X0 - X8 are modified and not preserved
//*****************************************************************************
// Algorithm/Pseudocode:
// 1) Check first element for '-'. If found, set negative flag and advance pointer
//    to next element
// 2) In a loop, scan through buffer and convert each digit to valid integer
//    and add to accumulator
// 3) In same loop, add the decimal flag to a counter. Initially, set the
//    the flag to 0. However, when decimal encountered, set flag to 1, enabling
//    easy counting of fractional part length
// 4) Break loop when null terminator encountered
// 5) Convert integer accumlator into double
//    * after conversion, if decimal flag set to 0, jump straight to step 8
// 6) In a loop, build divisor based on length of fractional part collected
// 7) Divide converted double value by divisor
// 8) Negate final double value if negative flag set.
//*****************************************************************************

.global cstr2dfp
cstr2dfp:

  .text
  // Set up accumulators and flags for parsing
  MOV X1, #0                    // integer accumulator for all digits parsed
  MOV X2, #0                    // sign flag, set to 0 if positive, 1 if negative
  MOV X3, #0                    // counter for fractional part length
  MOV X4, #10                   // constant 10 for multiply-by-ten step
  MOV X5, #0                    // decimal flag, set to 1 once '.' has been seen

  // Check minus sign
  LDRB W6, [X0]                 // grab first element
  CMP X6, #'-'                  // compare element with '-'
  B.NE parseLoop                // IF element != '-', then start parsing directly
  MOV X2, #1                    // ELSE element == '-', set flag
  ADD X0, X0, #1                // index++

  // In a loop traverse buffer and build accumulator
parseLoop:
  LDRB W6, [X0]                 // load current element
  CBZ X6, parseLoopExit         // IF element == null terminator, then break
  CMP X6, #'.'                  // compare element with '.'
  B.EQ setDecimal               // IF element == '.', then set flag
  SUB X6, X6, #'0'              // otherwise convert ascii to integer
  MUL X1, X1, X4                // accumulator * 10 to shift digits left
  ADD X1, X1, X6                // accumulator += new digit
  ADD X3, X3, X5                // counter += decimal flag (0 before '.', 1 after)
  ADD X0, X0, #1                // index++
  B parseLoop                   // reloop

  // Set decimal flag and skip past
setDecimal:
  MOV X5, #1                    // set decimal flag so future digits increment counter
  ADD X0, X0, #1                // index++
  B parseLoop                   // reloop

  // Convert accumulated integer into double
parseLoopExit:
  SCVTF D0, X1                  // convert integer accumulator to double and store in D0
  CBZ X3, negate                // IF no fractional digits, then skip scaling step

  // Build correct power of 10 using count of fractional digits
  FMOV D1, #1.0                 // accumulator starting at 1.0
  FMOV D2, #10.0                // multiplier for power of 10
power10Loop:
  FMUL D1, D1, D2               // accumulator * 10
  SUBS X3, X3, #1               // counter--
  B.NE power10Loop              // IF counter != 0, then reloop

  // Divide accumulated value by power of 10 to place decimal correctly
  FDIV D0, D0, D1               // D0 / 10^n | this places the decimal point correctly

  // Negate value if negative flag set
negate:
  CBZ X2, terminate             // IF sign flag == 0, then skip negation
  FNEG D0, D0                   // ELSE negate D0 to make it negative

  // Restore registers and return
terminate:
  RET                           // return

  .data
