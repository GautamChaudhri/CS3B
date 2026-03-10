  //*****************************************************************************
  // Gautam Chaudhri
  // 2/10/2026
  //
  // Algorithm/Pseudocode:
  // Topic 3
  //*****************************************************************************

.global _start
_start:
    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call

    .text

    // Prepare to terminate
    MOV X0, #0          // use 0 for return code success
    MOV X8, #SYS_exit   // service code to exit
    SVC 0               // call linux to exit 

    .data
szHelloWorld: .asciz "Hello World\n"
bOneByte: .byte 0xA
bTwoBytes: .byte 0x0, 0 //base of 0?
chTwoChar: .byte 'A', 66
i64AnInt: .quad 0x123456789ABCDEF0
u64UnsignInt: .quad 1234
i32AnInt: .word 0x1234ABCD
szInputBuf: .skip 30
bAbyte: .byte 'Z'
