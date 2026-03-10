.global sum_digits

   .text

sum_digits:

   // preserve registers per PCS
   STR   X19, [SP, #-16]!     // PUSH
   STR   X20, [SP, #-16]!     // PUSH
   STR   X21, [SP, #-16]!     // PUSH
   // 

   STR   LR, [SP, #-16]!     // PUSH LR/X30

   // Base Case - value is less than 10, so this is the most significant digit
   CMP   X0, #10
   B.LT  finish

   // General Case
recursion:
   MOV   X1,#10      // put 10 (base) in X1
   MOV   X21,X0      // save  passed value of X0
   SDIV  X19,X0,X1   // compute the quotient in X19
   // reconstruct the passed value less the remainder in X20
   MUL   X20,X19,X1  // X20 = int(n/10) * 10
   SUB   X20,X0,X20  // compute the remainder in X20, this will be accumlated

   MOV   X0,X19      // copy the quotient into X0 for the recursive call
   BL    sum_digits
   ADD   X0, X0, X20 // add the result of the recursion to the previous remainder

finish:

   // restore registers per PCS in reverse order
   LDR   LR,  [SP], #16       // POP
   LDR   X21, [SP], #16       // POP
   LDR   X20, [SP], #16       // POP
   LDR   X19, [SP], #16       // POP

   RET      LR          // Return to caller

.end