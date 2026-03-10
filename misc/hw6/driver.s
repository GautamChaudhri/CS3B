.global _start

   .text

_start:

   // load X0 with the integer whose digits will be summed
   MOV   X0, #18
   BL    sum_digits  // call the recursive routine sum_digits
                     // X0 will have the returned answer

   // Setup the parameters to exit the program
   // and then call Linux to do it.
   MOV   X0, #0      // Use 0 return code
   MOV   X8, #93     // Service command code 93 terminates this program
   SVC   0           // Call linux to terminate the program

.end