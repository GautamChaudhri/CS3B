//*****************************************************************************
// Gautam Chaudhri
// Apr 15, 2026
// lab
//
// Algorithm/Pseudocode:
// 1)
//*****************************************************************************

.global main
main:

  .text
  STR LR, [SP, #-16]!   // preserve LR

  LDR X0, =test1        // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test2        // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test3        // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test4        // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test5        // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test6        // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test7        // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test8        // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test9        // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test10       // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  LDR X0, =test11       // load test buffer
  BL cstr2dfp           // call function to convert
  LDR X0, =fmt          // setup parameters for printf
  BL printf             // call printf

  // Prepare to terminate
  LDR LR, [SP], #16    // restore LR
  RET

  .data
fmt:    .asciz  "%.20f\n"

test1:   .asciz  "-2.3993"
test2:   .asciz  "1.534000"
test3:   .asciz  "3.141592654"
test4:   .asciz  "0.00000000000000009999"
test5:   .asciz  "0.0"
test6:   .asciz  "-123456789012345678901234567890123456789012345678901234567890.0"
test7:   .asciz  "-9999999999.9999999999"
test8:   .asciz  "0.3333333333"
test9:   .asciz  "-0.67"
test10:  .asciz  "1.1"
test11:  .asciz  "100"
