//*****************************************************************************
// Gautam Chaudhri
// Mar 26, 2026
// This file contains common and useful macros made by me.
// All have been tested thoroughly and verified to work without bugs.
//*****************************************************************************

// Prints a null terminated string to console
// Input:  bufferLabel - label of null terminated string to print
// Output: None
// Modifies: X0
.macro PRINT bufferLabel
  LDR X0, =\bufferLabel   // load buffer
  BL putstring            // print buffer
.endm

// Prints \n to console
// Input:  None
// Output: None
// Modifies: X0
.macro PRINT_EOL
  LDR X0, =szEOL          // load '\n'
  BL putstring            // print '\n'
.endm

// Displays prompt and then captures and returns user input
// Input:  promptBuf - label of prompt string to display
//         fileBuf   - label of buffer to store user input
//         readSize  - immediate value, max number of bytes to read
// Output: User input stored in fileBuf
// Modifies: X0, X1
.macro GET_PROMPT_INPUT promptBuf, fileBuf, readSize
  LDR X0, =\promptBuf             // prompt to output
  BL putstring                    // print prompt to console
  LDR X0, =\fileBuf               // load filename buffer
  MOV X1, #\readSize              // load size of buffer
  BL getstring                    // get the input
.endm

// Opens a file. If error encountered, jumps to appropriate label
// Input:  fileBuf    - label of null terminated filename string
//         flagsReg   - register or immediate containing access mode flags
//         perReg     - register or immediate containing file permissions
//         fdReg      - register to store returned file descriptor
//         errorLabel - label to branch to if open fails
// Output: fdReg contains the file descriptor on success
// Modifies: X0, X1, X2, X3, X8, fdReg
.macro OPEN_FILE fileBuf, flagsReg, perReg, fdReg, errorLabel
  MOV X0, #AT_FDCWD               // file in current word directory
  LDR X1, =\fileBuf               // load file name
  MOV X2, \flagsReg               // load access mode flags
  MOV X3, \perReg                 // load permissions
  MOV X8, #SYS_openat             // service code to open file
  SVC 0                           // call OS to open file
  CMP X0, XZR                     // check returned file descriptor value
  B.LT \errorLabel                // IF fd is negative, then file failed to open
  MOV \fdReg, X0                  // ELSE save returned fd value
.endm

// Closes a file
// Input:  file_fd - register containing file descriptor to close
// Output: None
// Modifies: X0, X8
.macro CLOSE_FILE file_fd 
  MOV X0, \file_fd                // fd of file to close
  MOV X8, #SYS_close              // service code to close file
  SVC 0                           // call OS to close
.endm

// Outputs a file error prompt with the filename
// Input:  errorPrompt - label of error message string
//         filenameBuf - label of filename string that caused the error
// Output: None
// Modifies: X0
.macro OUTPUT_FILE_ERROR errorPrompt, filenameBuf
  LDR X0, =\errorPrompt             // load error prompt
  BL putstring                      // output error prompt
  LDR X0, =\filenameBuf             // load file name
  BL putstring                      // output file name
  LDR X0, =szEOL                    // load \n
  BL putstring                      // output \n
.endm

  .data
szEOL:        .asciz  "\n"  // new line
