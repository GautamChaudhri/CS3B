  //*****************************************************************************
  // Gautam Chaudhri
  // 2/12/2026
  // Lab 5-2 | int2cstr function
  //*****************************************************************************
  // Function int2cstr: Provided a signed integer, will convert it to a C-String 
  //                    stored stored in memory pointed to by a provided pointer
  //                    that must be large enough to hold the converted value. 
  //                    Usually a string of 21 bytes is more than sufficient to allow  
  //                    for a sign as well as the largest possible value a word could be.
  //
  // X0: Contains the binary (signed) value to be converted to a C-String
  // X1: Must point to address large enough to hold the converted value.
  // LR: Contains the return address (automatic when BL is used)
  // Registers X0 - X8 are modified and not preserved
  //*****************************************************************************
  // Algorithm/Pseudocode:
  // 1) Step through 
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
