  //*****************************************************************************
  // Gautam Chaudhri
  // 2/10/2026
  // Lab 5-1 - GDB Stories 
  //
  // Algorithm/Pseudocode:
  // 1)
  //*****************************************************************************

.global _start
_start:
    .EQU STDOUT, 1      // STDOUT
    .EQU SYS_write, 64  // write() system call
    .EQU SYS_exit, 93   // exit() system call

    .text
    LDR X0, =bA         // load memory address to store data in from label
    MOV X1, #155      // load register with wanted value
    STR X1, [X0]        // store value at correct address in memory

    LDR X0, =chInit     // load memory address to store data in from label
    MOV X1, #'j'        // load register with wanted value
    STR X1, [X0]        // store value at correct address in memory

    LDR X0, =u16Hi     // load memory address to store data in from label
    MOV X1, #88        // load register with wanted value
    STR X1, [X0]        // store value at correct address in memory

    LDR X0, =wAlt     // load memory address to store data in from label
    MOV X1, #16        // load register with wanted value
    STR X1, [X0]        // store value at correct address in memory
    ADD X0, X0, #4
    MOV X1, #-1        // load register with wanted value
    STR X1, [X0]
    ADD X0, X0, #4
    MOV X1, #2         // load register with wanted value
    STR X1, [X0]

    LDR X0, =szMsg1
    LDR X2, =szMsg1Input
    LDR X1, [X2]
    STR X1, [X0]

    // Prepare to terminate
    MOV X0, #0          // use 0 for return code success
    MOV X8, #SYS_exit   // service code to exit
    SVC 0               // call linux to exit 

    .data
bA:      .skip  1
chInit:  .skip  1
u16Hi:   .hword 0
wAlt:    .word  0, 0, 0
dbBig:   .quad  0
szMsg1:  .skip  50
szMsg1Input: .asciz "Sally says she sells sea shells"
