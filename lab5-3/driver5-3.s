//*****************************************************************************
// Gautam Chaudhri
// Feb 19, 2026
// lab5-3 - driver
//
// Tests cstr2int with 11 test values. For each test:
//   1) Load X0 with pointer to input string
//   2) Call cstr2int -> result lands in X1
//   3) Move result to X0, load X1 with buffer, call int2cstr to convert back
//   4) Print the resulting string followed by a newline
//*****************************************************************************

.global _start
_start:
  .EQU STDOUT, 1      // file descriptor: standard output
  .EQU SYS_write, 64  // Linux syscall number for write()
  .EQU SYS_exit, 93   // Linux syscall number for exit()

  .text

  // ----- test1: "99" -----
  LDR X0, =test1          // load X0 with pointer to test string "99"
  BL cstr2int             // call cstr2int; integer result returned in X1
  MOV X0, X1              // move integer result into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test2: "123456789" -----
  LDR X0, =test2          // load X0 with pointer to test string "123456789"
  BL cstr2int             // call cstr2int; integer result returned in X1
  MOV X0, X1              // move integer result into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test3: "1" -----
  LDR X0, =test3          // load X0 with pointer to test string "1"
  BL cstr2int             // call cstr2int; integer result returned in X1
  MOV X0, X1              // move integer result into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test4: "-1111" -----
  LDR X0, =test4          // load X0 with pointer to test string "-1111"
  BL cstr2int             // call cstr2int; integer result returned in X1
  MOV X0, X1              // move integer result into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test5: "0" -----
  LDR X0, =test5          // load X0 with pointer to test string "0"
  BL cstr2int             // call cstr2int; integer result returned in X1
  MOV X0, X1              // move integer result into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test6: "-9223372036854775808" (INT64_MIN, valid) -----
  LDR X0, =test6          // load X0 with pointer to test string "-9223372036854775808"
  BL cstr2int             // call cstr2int; integer result returned in X1
  MOV X0, X1              // move integer result into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test7: "-9223372036854775809" (should overflow) -----
  LDR X0, =test7          // load X0 with pointer to test string "-9223372036854775809"
  BL cstr2int             // call cstr2int; overflow -> returns 0 in X1
  MOV X0, X1              // move integer result (0) into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test8: "9223372036854775807" (INT64_MAX, valid) -----
  LDR X0, =test8          // load X0 with pointer to test string "9223372036854775807"
  BL cstr2int             // call cstr2int; integer result returned in X1
  MOV X0, X1              // move integer result into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test9: "9223372036854775808" (should overflow) -----
  LDR X0, =test9          // load X0 with pointer to test string "9223372036854775808"
  BL cstr2int             // call cstr2int; overflow -> returns 0 in X1
  MOV X0, X1              // move integer result (0) into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test10: "9223372036854775809" (should overflow) -----
  LDR X0, =test10         // load X0 with pointer to test string "9223372036854775809"
  BL cstr2int             // call cstr2int; overflow -> returns 0 in X1
  MOV X0, X1              // move integer result (0) into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- test11: "999999999999999999999" (should overflow) -----
  LDR X0, =test11         // load X0 with pointer to test string "999999999999999999999"
  BL cstr2int             // call cstr2int; overflow -> returns 0 in X1
  MOV X0, X1              // move integer result (0) into X0 for int2cstr
  LDR X1, =szStrBuffer    // load X1 with pointer to output string buffer
  BL int2cstr             // convert integer in X0 to c-string at X1
  LDR X0, =szStrBuffer    // load X0 with pointer to output string buffer for printing
  BL putstring            // print the converted c-string
  LDR X0, =szEOL          // load X0 with pointer to newline string
  BL putstring            // print newline

  // ----- terminate program -----
  MOV X0, #0              // set return code to 0 (success)
  MOV X8, #SYS_exit       // load syscall number for exit()
  SVC 0                   // call Linux to terminate the program


  .data
szStrBuffer: .skip 24     // 24-byte buffer to hold converted integer string (avoids alignment issues)
szEOL:       .asciz "\n"  // newline string for output formatting

test1:  .asciz   "99"
test2:  .asciz   "123456789"
test3:  .asciz   "1"
test4:  .asciz   "-1111"
test5:  .asciz   "0"
test6:  .asciz  "-9223372036854775808"
test7:  .asciz  "-9223372036854775809"    // this should overflow
test8:  .asciz  "9223372036854775807"
test9:  .asciz  "9223372036854775808"     // this should overflow
test10: .asciz  "9223372036854775809"     // this should overflow
test11: .asciz  "999999999999999999999"   // this should overflow