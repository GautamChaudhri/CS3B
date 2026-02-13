  //*****************************************************************************
  // Gautam Chaudhri
  // 2/10/2026
  // Lab 5-1 - GDB Stories 
  //
  // Algorithm/Pseudocode:
  // 1) For first three variables
  //    a) load register with target memory address to make pointer
  //    b) load another register with target value
  //    c) store value in memory 
  //
  // 2) For wAlt
  //    a) same steps as 1
  //    b) advance pointer by 4 bytes
  //    c) load store next value
  //    d) repeat one more time
  //
  // 3) For dbBig
  //    a) setup pointer
  //    b) use MOV and MOK to store target value in register 16 bits at a time
  //    c) store value in memory
  //
  // 4) For szMsg1
  //    a) setup pointers for both input and output arrays
  //    b) loop through input array char-by-char 
  //    c) store each char to output array in memory
  //    d) break when null-terminator encountered and copy it over too
  //
  // 5) Call Linux to terminate
  //*****************************************************************************

.global _start
_start:
  .EQU STDOUT, 1      // STDOUT
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  .text
  // Store bA
  LDR X0, =bA         // load register with target memory address
  MOV X1, #155      // load register with target value
  STR X1, [X0]        // store value in memory

  // Store chInit
  LDR X0, =chInit     // load register with target memory address
  MOV X1, #'j'        // load register with target value
  STR X1, [X0]        // store value in memory

  // Store u16Hi
  LDR X0, =u16Hi      // load register with target memory address
  MOV X1, #88         // load register with target value
  STR X1, [X0]        // store value in memory

  // Store wALT array, element by element manually
  LDR X0, =wAlt       // load register with target memory address
  MOV X1, #16         // load register with target value
  STR X1, [X0]        // store value in memory
  ADD X0, X0, #4      // advance target address (pointer) by 4 bytes
  MOV X1, #-1         // load register with target value
  STR X1, [X0]        // store value in memory
  ADD X0, X0, #4      // advance target address (pointer) by 4 bytes
  MOV X1, #-2         // load register with target value
  STR X1, [X0]        // store value in memory

  // Store dbBig
  LDR X0, =dbBig              // load register with target memory address
  MOV X1, #0x5B07             // load bottom 16 bits
  MOVK X1, #0x54E7, LSL #16   // load next 16 bits above that
  MOVK X1, #0xF36D, LSL #32   // load next 16 bits above that
  MOVK X1, #0x3A72, LSL #48   // load upper 16 bits
  STR X1, [X0]                // store value in memory

  // Loop through szMsg1 and store char by char
  LDR X0, =szMsg1Input    // load pointer for input array
  LDR X1, =szMsg1         // load pointer for output array

  loop_start:
  LDRB W2, [X0], #1       // load character at szMsg1Input[baseIndex++]
  CMP W2, #0              // compare current character to null-terminator
  B.EQ termination        // IF character in W2 is null-terminator, then jump to termination
  STR X2, [X1]            // ELSE copy character over to output array szMsg1
  ADD X1, X1, #1          // index++ for output array
  B loop_start            // reloop

  termination:
  MOV X1, X2              // copy over null terminator

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
