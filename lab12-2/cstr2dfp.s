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
// 2) In a loop, scan through buffer until decimal is discovered
//    * if decimal is discovered, then overwrite with null terminator
//    * if no decimal is discovered, then no fractional part, jump to special
//      handling
// 3) Feed modified buffer from first index to cstr2int to convert whole number 
//    part to integer. Then convert and store in D register
// 4) Feed modified buffer from first index after decimal point to String_length
//    to get length of fractional part
// 5) Build power of 10 divisor based on length of fractional part (e.g. if length
//    is 3, then divisor = 1000)
// 6) Feed modified buffer from first index after decimal point to cstr2int
//    to convert fractional part to integer
// 7) Convert and store fractional part in D register, then divide by divisor
//    and add to D register with whole number part.
// 8) Negate final answer based on negative flag
// 9) Special Case: if special case discovered in step 2, then only do step 3
//    and terminate
//*****************************************************************************

.global cstr2dfp
cstr2dfp:

  .text
  // Preserve PCS registers
  STP X9, X10, [SP, #-16]!    // preserve X9 and X10
  STP X11, LR, [SP, #-16]!    // preserve X11 and LR

  // Handle negative values manually
  MOV X11, XZR        // flag, set to 0 if positive, 1 if negative
  LDRB W1, [X0]       // grab first element
  CMP X1, #'-'         // compare element with '-'
  B.NE findDecimal    // IF element != '-', then jump to next section
  MOV X11, #1         // ELSE element == '-', set flag
  ADD X0, X0, #1      // index++

  // In a loop traverse array to find decimal
findDecimal:
  MOV X9, X0          // first save buffer start
findDecimalLoop:
  LDRB W1, [X0]       // load current element
  CMP X1, #'.'        // compare element with '.'
  B.EQ findDecimalExit  // IF element == '.', then exit loop
  CBZ X1, noDecimalExit // ELSE IF element == null terminator, then exit to special case
  ADD X0, X0, #1      // ELSE index++
  B findDecimalLoop   // and reloop
  
  // Use cstr2int to convert whole number part
findDecimalExit:
  ADD X10, X0, #1     // save index of first elment after decimal
  STRB WZR, [X0]      // overwrite decimal with null terminator
  MOV X0, X9          // move buffer start to X0, where cstr2int wants it
  BL cstr2int         // call cstr2int to convert
  SCVTF D0, X0        // convert integer to double and store in D0

  // Find and save how many decimal place values
  MOV X0, X10         // load first index of fractional part
  BL String_length    // call function to get number of decimal place values
  SUB X0, X0, #1      // subtract 1 from String_length result to not count null terminator

  // Build correct power of 10 using length of decimal values
  FMOV D1, #1.0       // accumulator starting at 10
  FMOV D2, #10.0      // number to multiply accumulator by to get power of 10
power10Loop:
  CBZ X0, power10Exit // using String_length result as counter, break when == 0
  FMUL D1, D1, D2     // accumulator * 10
  SUB X0, X0, #1      // counter--
  B power10Loop       // reloop

  // Convert fractional part to integer
power10Exit:
  MOV X0, X10         // load first index of fractional part
  BL cstr2int         // call function to convert to integer

  // Convert from integer into valid original fractional part but as double
  SCVTF D2, X0        // convert decimal part from integer into double
  FDIV D1, D2, D1     // decimal part as integer / correct power of 10 | this gets original fractional part as double
  FADD D0, D0, D1     // add valid fractional part to whole number part
  MOV X1, #'.'        // load '.'
  STRB W1, [X10, #-1] // restore decimal point to buffer
  CBNZ X11, negate    // IF negative flag set, then deal with it
  B terminate         // ELSE jump to termination

  // Special case for when no decimal present
noDecimalExit:
  MOV X0, X9          // move buffer start to X0, where cstr2int wants it
  BL cstr2int         // call cstr2int to convert
  SCVTF D0, X0        // convert integer to double and store in D0
  CBNZ X11, negate    // IF negative flag set, then deal with it
  B terminate         // ELSE jump to termination

negate:
  FCMP D0, #0.0       // compare D0 with 0.0
  B.EQ terminate      // IF D0 == 0.0, then dont negate
  FNEG D0, D0         // ELSE negate D0 to make it negative
  B terminate         // jump to termination

terminate:
  LDP X11, LR, [SP], #16  // restore X11 and LR
  LDP X9, X10, [SP], #16  // restore X9 and X10
  RET                     // return

  .data
