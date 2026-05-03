//*****************************************************************************
// Gautam Chaudhri
// Mar 26, 2026
// This file contains common and useful macros made by me.
// All have been tested thoroughly and verified to work without bugs.
//*****************************************************************************



//*****************************************************************************
// MACRO: PRINT - prints a buffer to a console
// INPUT:   * bufferLabel: a label to a null-terminated cstring
//
// OUTPUT:  * N/A
//
// MODIFIES: * X0
//*****************************************************************************
// Algorithm:
// 1) Load target buffer
// 2) Call putstring to print buffer to console
//*****************************************************************************
.macro PRINT bufferLabel
  LDR X0, =\bufferLabel   // load buffer
  BL putstring            // print buffer
.endm


//*****************************************************************************
// MACRO: PRINT_EOL - prints newline character to console
// INPUT:   * N/A
//
// OUTPUT:  * N/A
//
// MODIFIES: * X0
//*****************************************************************************
// Algorithm:
// 1) Load buffer containing newline character
// 2) Call putstring to print newline to console
//*****************************************************************************
.macro PRINT_EOL
  LDR X0, =szEOL          // load '\n'
  BL putstring            // print '\n'
.endm


//*****************************************************************************
// MACRO: PUSH1 - pushes a single register onto the stack
// INPUT:   * reg: register to push onto the stack
//
// OUTPUT:  * N/A
//
// MODIFIES: * SP
//*****************************************************************************
// Algorithm:
// 1) Use STR and push syntax to push target register to stack
//*****************************************************************************
.macro PUSH1 reg
    STR \reg, [SP, #-16]!
.endm


//*****************************************************************************
// MACRO: POP1 - pops a single register off the stack
// INPUT:   * reg: register to pop off the stack
//
// OUTPUT:  * N/A
//
// MODIFIES: * SP, reg
//*****************************************************************************
// Algorithm:
// 1) Use LDR and pop syntax to pop top of stack into target register
//*****************************************************************************
.macro POP1 reg
    LDR \reg, [SP], #16
.endm


//*****************************************************************************
// MACRO: PUSH2 - pushes two registers onto the stack
// INPUT:   * reg1: first register to push onto the stack
//          * reg2: second register to push onto the stack
//
// OUTPUT:  * N/A
//
// MODIFIES: * SP
//*****************************************************************************
// Algorithm:
// 1) Use STP and push syntax to push two registers onto the stack
//*****************************************************************************
.macro PUSH2 reg1, reg2
    STP \reg1, \reg2, [SP, #-16]!
.endm


//*****************************************************************************
// MACRO: POP2 - pops two registers off the stack
// INPUT:   * reg1: first register to pop off the stack
//          * reg2: second register to pop off the stack
//
// OUTPUT:  * N/A
//
// MODIFIES: * SP, reg1, reg2
//*****************************************************************************
// Algorithm:
// 1) Use LDP and pop syntax to pop top of stack into two target registers
//*****************************************************************************
.macro POP2 reg1, reg2
    LDP \reg1, \reg2, [SP], #16
.endm


//*****************************************************************************
// MACRO: GET_PROMPT_INPUT - displays a prompt then captures user input
// INPUT:   * promptBuf: label of prompt string to display
//          * fileBuf:   label of buffer to store user input
//          * readSize:  immediate value, max number of bytes to read
//
// OUTPUT:  * User input stored in fileBuf
//
// MODIFIES: * X0, X1
//*****************************************************************************
// Algorithm:
// 1) Load prompt buffer and call putstring to display it
// 2) Load input buffer and max read size
// 3) Call getstring to capture user input into the buffer
//*****************************************************************************
.macro GET_PROMPT_INPUT promptBuf, fileBuf, readSize
  LDR X0, =\promptBuf             // prompt to output
  BL putstring                    // print prompt to console
  LDR X0, =\fileBuf               // load filename buffer
  MOV X1, #\readSize              // load size of buffer
  BL getstring                    // get the input
.endm


//*****************************************************************************
// MACRO: OPEN_FILE - opens a file, branches to error label on failure
// INPUT:   * fileBuf:    label of null-terminated filename string
//          * flagsReg:   register or immediate with access mode flags
//          * perReg:     register or immediate with file permissions
//          * fdReg:      register to store returned file descriptor
//          * errorLabel: label to branch to if open fails
//
// OUTPUT:  * fdReg contains the file descriptor on success
//
// MODIFIES: * X0, X1, X2, X3, X8, fdReg
//*****************************************************************************
// Algorithm:
// 1) Load AT_FDCWD into X0 to open relative to current working directory
// 2) Load filename, access flags, and permissions into X1, X2, X3
// 3) Set service code SYS_openat in X8 and trigger syscall
// 4) IF returned fd is negative, branch to error label
// 5) ELSE save returned fd into target register
//*****************************************************************************
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


//*****************************************************************************
// MACRO: CLOSE_FILE - closes an open file
// INPUT:   * file_fd: register containing file descriptor to close
//
// OUTPUT:  * N/A
//
// MODIFIES: * X0, X8
//*****************************************************************************
// Algorithm:
// 1) Load file descriptor into X0
// 2) Set service code SYS_close in X8 and trigger syscall
//*****************************************************************************
.macro CLOSE_FILE file_fd 
  MOV X0, \file_fd                // fd of file to close
  MOV X8, #SYS_close              // service code to close file
  SVC 0                           // call OS to close
.endm


//*****************************************************************************
// MACRO: OUTPUT_FILE_ERROR - prints a file error message followed by filename
// INPUT:   * errorPrompt: label of error message string
//          * filenameBuf: label of filename string that caused the error
//
// OUTPUT:  * N/A
//
// MODIFIES: * X0
//*****************************************************************************
// Algorithm:
// 1) Load and print error prompt
// 2) Load and print offending filename
// 3) Load and print newline character
//*****************************************************************************
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
