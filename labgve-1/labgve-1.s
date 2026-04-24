//*****************************************************************************
// Gautam Chaudhri
// Apr 24, 2026
// lab gve-1 - Bad Credit
//
// Algorithm/Pseudocode:
// 1) Output strings to be concatenated to console
// 2) Accumulate lengths of all strings. Account for final null terminator too
// 3) Call malloc to allocate memory
// 4) Copy each string into newly allocated buffer, overwriting previous strings
//    null terminator
//    * copy each element in a loop, break loop after null terminator reached
// 5) Print newly concatenated string to console along
// 6) Free allocated memory
//*****************************************************************************

.global _start
_start:
  /// Standard Aliases
  .EQU STDIN, 0       // STDIN
  .EQU STDOUT, 1      // STDOUT
  .EQU STDERR, 2      // STDERR
  .EQU SYS_read, 63   // read() system call
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  // MACRO: prints buffer to console using putstring
.macro PRINT bufferLabel
  LDR X0, =\bufferLabel   // load buffer
  BL putstring            // print buffer
.endm
  // MACRO: prints newline to console using putstring
.macro PRINT_EOL
  LDR X0, =szEOL          // load '\n'
  BL putstring            // print '\n'
.endm
  // MACRO: copies buffer contents to another buffer
  // Takes pointer to buffers in registers
.macro COPY_BUFFER sourceBufReg, destBufReg
copyLoop_\@:              // \@ = macro counter, used by GAS to generate unique labels
  MOV X0, \sourceBufReg   // load source buffer
  MOV X1, \destBufReg     // load destination buffer
  LDRB W2, [X0]           // load current element from source
  STRB W2, [X1]           // store element in destination
  ADD X0, X0, #1          // source pointer++
  ADD X1, X1, #1          // destination pointer++
  CBNZ X2, copyLoop_\@    // IF element != null terminator, reloop
.endm

  .text
  // Output strings to be concatenated to console
  PRINT szString1     // print first string
  PRINT_EOL           // print newline
  PRINT szSeparator   // print seperator
  PRINT_EOL           // print newline
  PRINT szString2     // print second string
  PRINT_EOL           // print newline
  
  // Accumulate string lengths
  MOV X3, #0          // accumulator set to 0
  LDR X0, =szString1  // load buffer
  BL String_length    // call function
  ADD X3, X3, X0      // accumulator += length
  SUB X3, X3, #1      // accumulator-- to not count null terminator
  LDR X0, =szSeparator  // load buffer
  BL String_length    // call function
  ADD X3, X3, X0      // accumulator += length
  SUB X3, X3, #1      // accumulator-- to not count null terminator
  LDR X0, =szString2  // load buffer
  BL String_length    // call function
  ADD X3, X3, X0      // accumulator += length

  // Allocate memory
  MOV X0, X3          // move accumulated lengths into X0
  BL malloc           // call malloc to allocate memory
  LDR X1, =pszStrPtr  // load pointer label
  STR X0, [X1]        // store allocated mem pointer at label

  // Copy source buffer to destination
  LDR X0, =szString1  // load source buffer
  LDR X1, =pszStrPtr  // load label to pointer to destination buffer
  LDR X1, [X1]        // load pointer to destination buffer
  COPY_BUFFER X0, X1  // copy buffer
  LDR X0, =szSeparator  // load next source buffer
  SUB X1, X1, #1      // destination pointer--, now pointing to last copied null terminator
  COPY_BUFFER X0, X1  // copy buffer
  LDR X0, =szString2  // load last source buffer
  SUB X1, X1, #1      // destination pointer--, now pointing to last copied null terminator
  COPY_BUFFER X0, X1  // copy buffer

  // Print concantenated string
  LDR X0, =pszStrPtr  // load label to pointer to destination buffer
  LDR X0, [X0]        // load pointer from destination buffer
  BL putstring        // print buffer to console
  PRINT_EOL           // print newline

  // Free allocated memory
  //LDR X0, =pszStrPtr  // load allocated memory pointer
  //LDR X0, [X0]        // load actual pointer
  //BL free             // call free to free memory

  // Prepare to terminate
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call linux to exit 

  .data
szString1:   .asciz "Mal (bad)"            // a C-String 
szSeparator: .asciz " "                    // a C-String separator that is just a space this time
szString2:   .asciz "loc (line-of-credit)" // another C-String 
pszStrPtr:   .quad  0                      // a pointer to a C-String for the output

szEOL:       .asciz  "\n"  // new line
