//*****************************************************************************
// Gautam Chaudhri
// Mar 31, 2026
// lab7-3 Bubble Gum Driver
//
// Algorithm/Pseudocode:
// 1) Setup input and output files.
// 2) In a loop, traverse input file and grab each integer, convert from cstring
//    into valid integer, and store in integer array.
//    * break when loop counter hits MAX_ARRAY_SIZE (100) or end of file is reached.
//    * integer array should be setup for a quad (8 byte) element size
// 3) Upon exiting loop, try to read one more line from file. If number of characters
//    read is greater than 0, then display MAX_ARRAY_SIZE warning.
// 4) Call bubblesort to sort array into ascending order.
// 5) Grab actual size of array, smallest integer from beginning of array, and
//    largest integer from end of array, and display summary.
// 6) In a loop, grab each integer from array, convert to cstring, and store
//    in output file.
//    * break when entire integer array is traversed
//*****************************************************************************

.global _start
_start:
  .include "macros.s" // include macro file

  /// Standard Aliases
  .EQU STDIN, 0       // STDIN
  .EQU STDOUT, 1      // STDOUT
  .EQU STDERR, 2      // STDERR
  .EQU SYS_read, 63   // read() system call
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  // File Operation Aliases
  .EQU AT_FDCWD, -100 // Filename relevant to current directory
  .EQU F_RDONLY, 00   // ACCESS MODE: read only
  .EQU F_WRONLY, 01   // ACCESS MODE: write only
  .EQU F_RDWR, 02     // ACCESS MODE: read and write
  .EQU F_CREAT, 0100  // FLAG: create file if nonexistent
  .EQU F_EXCLC, 0200  // FLAG: exclusive create, fail if file already exists
  .EQU F_TRUN, 01000  // FLAG: truncate existing file
  .EQU F_APPD, 02000  // FLAG: append to existing file
  .EQU P_RDWR, 0666   // PERMISSIONS: global read/write
  .EQU SYS_openat, 56 // Linux openat()
  .EQU SYS_close, 57  // Linux close()

  // Current Lab Aliases
  .EQU MAX_ARRAY_SZ, 100  // max array size
  .EQU EL_SIZE, 8         // size of each element = quad = 8
  .EQU MAX_CHAR_LEN, 22   // max characters contained in a quad integer
  .EQU FILENAME_SIZE, 64  // max file name size

  .text
  // Setup input file
  GET_PROMPT_INPUT szInFilePrompt, szInFile, FILENAME_SIZE  // get input file name
  MOV X7, #F_RDONLY       // load access mode
  MOV X8, #P_RDWR         // load file permissions
  OPEN_FILE szInFile, X7, X8, X4, inFileError   // attemp to open file, save fd to X4

  // Setup output file
  GET_PROMPT_INPUT szOutFilePrompt, szOutFile, FILENAME_SIZE  // get output file name
  MOV X7, #F_WRONLY       // load access mode
  ADD X7, X7, #F_CREAT    // add create flag
  ADD X7, X7, #F_TRUN     // add truncate flag
  MOV X8, #P_RDWR         // load file permissions
  OPEN_FILE szOutFile, X7, X8, X5, outFileError   // attemp to open file, save fd to X5
  STR X5, [SP, #-16]!     // save outFile fd until it is needed later

  // Load integers from inFile into integer array
  MOV X9, #MAX_ARRAY_SZ   // loop counter set to 100
  LDR X10, =rg64Arr       // load integer array buffer
  STR X4, [SP, #-16]!     // save inFile fd
intArrLoadLoop:
  CBZ X9, intArrLoadLoopExit  // IF counter == 0, then break loop
  LDR X0, [SP], #16       // load inFile fd
  STR X0, [SP, #-16]!     // save inFile fd for next loop
  LDR X1, =szIntBuf       // load buffer to hold cstring integer
  MOV X2, #MAX_CHAR_LEN   // load size of buffer
  BL getline              // call getline to get integer from inFile
  CBZ X0, intArrLoadLoopExit  // if getline returned 0 characters read, then break
  LDR X0, =szIntBuf       // load cstring buffer from beginning into X0
  LDRB W1, [X0]           // load first byte of buffer
  CBZ X1, intArrLoadLoopExit // IF first byte == null terminator THEN not valid integer, break loop
  BL cstr2int             // convert cstring integer to valid integer
  STR X0, [X10], #EL_SIZE // store integer into array buffer and advance pointer to next element
  SUB X9, X9, #1          // counter--
  B intArrLoadLoop        // reloop

intArrLoadLoopExit:
  // Check if inFile warning applies
  LDR X0, [SP], #16       // pop inFile fd
  LDR X1, =szIntBuf       // load buffer to hold cstring integer
  MOV X2, #MAX_CHAR_LEN   // load size of buffer
  BL getline              // call getline to get integer from inFile
  CBZ X0, bubbleSortStep  // IF getline returns 0 characters read, then skip displaying warning
  LDR X0, =szIntBuf       // load cstring buffer from beginning into X0
  LDRB W1, [X0]           // load first byte of buffer
  CBZ X1, bubbleSortStep  // ELSE IF first byte == null terminator THEN not valid integer, skip warning

  // Display warning
  MOV X0, #MAX_ARRAY_SZ   // ELSE display warning, load max array size
  LDR X1, =szIntBuf       // load buffer to hold converted cstring
  BL int2cstr             // call function to convert int to cstring
  PRINT szEntriesWarning1 // display part 1 of warning
  PRINT szIntBuf          // display max array size
  PRINT szEntriesWarning2 // display part 2 of warning
  PRINT szInFile          // display file name
  PRINT szEntriesWarning3 // display last part of warning
  PRINT_EOL               // display '\n'

  // Bubble sort integer array
bubbleSortStep:
  LDR X0, =rg64Arr        // load integer array into X0
  SUB X1, X9, #100      // calculate size of array
  NEG X1, X1              // negate size of array to make positive
  STR X1, [SP, #-16]!     // also save array size on the stack
  BL bubblesort           // call bubble sort to sort array

  // Display bubble sort summary
  LDR X0, [SP], #16       // pop array size
  STR X0, [SP, #-16]!     // save array size for later
  LDR X1, =szIntBuf       // load buffer to hold converted cstring
  BL int2cstr             // call function to convert
  PRINT szValuesRead      // display values read prompt
  PRINT szIntBuf          // dispaly number of values read
  PRINT_EOL               // display '\n'
  LDR X0, =rg64Arr        // load integer array
  LDR X0, [X0]            // load smallest value
  LDR X1, =szIntBuf       // load buffer to hold converted value
  BL int2cstr             // call function to convert
  PRINT szMinValue        // display miniumum value prompt
  PRINT szIntBuf          // display minimum value
  PRINT_EOL               // print '\n'
  LDR X1, [SP], #16       // pop array size
  STR X1, [SP, #-16]!     // save array size for later
  SUB X1, X1, #1          // subtract 1 to get last index
  MOV X2, #EL_SIZE        // load element size
  MUL X1, X1, X2          // multiply by element size to get correct offset for last index
  LDR X0, =rg64Arr        // load integer array
  ADD X0, X0, X1          // add offset to array base index to get last index
  LDR X0, [X0]            // load last index
  LDR X1, =szIntBuf       // load buffer to hold converted cstring
  BL int2cstr             // call function to convert
  PRINT szMaxValue        // display maximum value prompt
  PRINT szIntBuf          // display maximum value
  PRINT_EOL               // print '\n'

  // Store sorted integer array into outFile
  LDR X9, [SP], #16       // pop array size to serve as counter
  LDR X10, =rg64Arr       // load integer array
outFileLoadLoop:
  // Convert integer to cstring and get its length
  CBZ X9, terminate       // IF counter == 0, then break loop
  LDR X0, [X10], #EL_SIZE // load integer from array and advance pointer to next element
  LDR X1, =szIntBuf       // load buffer to hold converted cstring
  BL int2cstr             // call function to convert integer to string
  LDR X0, =szIntBuf       // move buffer to X0
  BL String_length        // call function to get string length

  // Overwrite null terminator in cstring with '\n'
  LDR X1, =szIntBuf       // load converted cstring
  ADD X1, X1, X0          // index = 1 past null terminator
  SUB X1, X1, #1          // index = null terminator
  MOV X2, #10             // load '\n' ascii value
  STRB W2, [X1]           // overwrite null terminator with '\n'

  // Write cstring to file
  MOV X2, X0              // move string length to X2
  LDR X0, [SP], #16       // pop outFile fd
  STR X0, [SP, #-16]!     // save outFile fd again for next loop
  LDR X1, =szIntBuf       // load converted cstring
  MOV X8, #SYS_write      // linux write service code
  SVC 0                   // call linux to write to file
  SUB X9, X9, #1          // counter--
  B outFileLoadLoop       // reloop

terminate:
  // Prepare to terminate
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call linux to exit

inFileError:
  OUTPUT_FILE_ERROR szInFileError, szInFile   // display input file error
  B terminate                                 // jump to terminate

outFileError:
  OUTPUT_FILE_ERROR szOutFileError, szOutFile // display output file error
  B terminate                                 // jump to terminate

  .data
rg64Arr:             .skip     MAX_ARRAY_SZ * EL_SIZE
szIntBuf:            .skip     21            // holds cstring result after integer is converted


szInFile:           .skip     FILENAME_SIZE
szOutFile:          .skip     FILENAME_SIZE

szInFilePrompt:     .asciz    "Enter input file name  : "
szOutFilePrompt:    .asciz    "Enter output file name : "

szInFileError:      .asciz    "Fatal error: failed to open input file "
szOutFileError:     .asciz    "Fatal error: failed to open output file "

szEntriesWarning1:  .asciz    "Warning: more than "
szEntriesWarning2:  .asciz    " entries found in input file "
szEntriesWarning3:  .asciz    ". Ignoring additional entries."

szValuesRead:       .asciz    "Number of values read  : "
szMinValue:         .asciz    "Smallest value read    : "
szMaxValue:         .asciz    "Largest Value read     : "
