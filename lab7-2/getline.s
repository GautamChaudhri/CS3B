//*****************************************************************************
// Gautam Chaudhri
// Mar 26, 2026
// lab7-2 - getstring
//*****************************************************************************
// Function getline:  Provided a file descriptor, max characters to read count, 
//                    and a pointer to a buffer large enought to hold that max,
//                    return the number of characters read (including '\n') and
//                    a line from the file stored in the buffer as a C-String
//                    (excluding any '\n').
//
//  X0: Must be a file descriptor for a file successfully opened for read
//      access by the caller. On return from the function, X0 should hold the
//      number bytes read, including the '\n' if it was encountered.
//  X1: Points to the first byte of the buffer to receive the line. This must
//      be preserved (i.e. X1 should still point to the buffer when this function
//      returns).
//  X2: The maximum length of the buffer pointed to by X1 (note this length
//      should account for the null termination of the read line (i.e. C-String)
//  LR: Must contain the return address (automatic when BL
//      is used for the call)
//  Registers X0 - X8 are modified and not preserved
//*****************************************************************************
// Algorithm/Pseudocode:
// 1) In a loop, read a single byte from file and store in buffer
// 2) Exit loop if any one of 3 conditions met:
//    * A) most recent byte contained \n
//    * B) 0 bytes read from SYS function call
//    * C) number of total bytes read == maximum bytes to read (buffer size)
// 3) Place null terminator at least read byte
//*****************************************************************************

.global getline
getline:
  // Standard Aliases
  .EQU STDIN, 0       // STDIN
  .EQU STDOUT, 1      // STDOUT
  .EQU STDERR, 2      // STDERR
  .EQU SYS_read, 63   // read() system call
  .EQU SYS_write, 64  // write() system call
  .EQU SYS_exit, 93   // exit() system call

  // File Operation Aliases
  .EQU AT_FDCWD, -100 // filename relevant to current directory
  .EQU O_RDONLY, 0    // read only mode
  .EQU O_WRONLY, 1    // write only mode
  .EQU O_CREAT, 0100  // create file if nonexistent
  .EQU O_EXCL, 0200   // exclusive create, fail if file already exists
  .EQU O_RDWR, 0666   // file permissions, read/write global
  .EQU SYS_openat, 56 // Linux openat()
  .EQU SYS_close, 57  // Linux close()

  .text
  MOV X6, X0              // save fd to prevent overwrites
  SUB X7, X2, #1          // save maximum length - 1 to read
  MOV X3, XZR             // serves as loop counter

readLoop:
  // Read one byte - fd and buffer already in correct registers
  ADD X3, X3, #1          // counter++
  MOV X2, #1              // read only one byte
  MOV X8, #SYS_read       // service code for read
  SVC 0                   // call OS to read

  // Exit if any one of three conditions met
  LDRB W4, [X1]           // load most recent read byte
  CMP X4, #10             // 1) IF read byte == '\n'
  B.EQ placeNull          //    then exit loop
  CBZ X0, placeNull       // 2) ELSE IF 0 bytes read, then exit loop
  CMP X3, X7              // 3) ELSE IF counter == max bytes to read
  B.EQ placeNullPast      //    then exit loop

  ADD X1, X1, #1          // OTHERWISE advance buffer pointer
  MOV X0, X6              // restore fd
  B readLoop              // and reloop

placeNull:
  STR XZR, [X1]           // overwrite current index with null terminator
  RET                     // return

placeNullPast:
  ADD X1, X1, #1          // advance buffer pointer so null is placed one index past current
  B placeNull             // jump to write
  

  .data
