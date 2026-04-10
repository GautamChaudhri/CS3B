//*****************************************************************************
// Gautam Chaudhri
// Apr 9, 2026
// lab12-1 - And your point is
//
// Algorithm/Pseudocode:
// 1) Load all 6 variables into floating point registers.
// 2) Carry out the 3 computations and place their values into correct registers.
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

  .text
  // Load all variables into registers
  LDR X0, =dbVal1     // load first variable
  LDR S0, [X0]        // load value from first variable
  LDR X0, =dbVal2     // load second variable
  LDR S1, [X0]        // load value from second variable
  LDR X0, =dbVal3     // load third variable
  LDR S3, [X0]        // load value from third variable
  LDR X0, =dbVal4     // load fourth variable
  LDR S4, [X0]        // load value from fourth variable
  LDR X0, =dbVal5     // load fifth variable
  LDR S6, [X0]        // load value from fifth variable
  LDR X0, =dbVal6     // load sixth variable
  LDR S7, [X0]        // load value from sixth variable

  FADD S2, S0, S1     // S2 = S0 + S1
  FSUB S5, S3, S4     // S5 = S3 + S4
  FADD S8, S6, S7     // S8 = S6 + S7

  // Prepare to terminate
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call linux to exit 

  .data
dbVal1:     .single   2.3993
dbVal2:     .single   51.31
dbVal3:     .single   1.534000 
dbVal4:     .single   1.534443
dbVal5:     .single   3.14e2
dbVal6:     .single   5.55e-4
