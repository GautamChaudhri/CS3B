  //*****************************************************************************
  // Gautam Chaudhri
  // 1/27/2026
  //
  // Algorithm/Pseudocode:
  // Learning basic MOV and shifts
  // Topic 2: Basic GDB using MOV
  //*****************************************************************************

.global _start 
_start:
    MOV X2, #3

    MOV X1, X2, LSR #1
    MOV X1, X2, ASR #1
    MOV X1, X2, ROR #1

    LSL X1, X2, #1
    LSR X1, X2, #1
    ASR X1, X2, #1
    ROR X1, X2, #1

.end