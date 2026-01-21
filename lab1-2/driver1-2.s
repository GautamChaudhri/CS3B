// George Eaton
// CS3B - lab1-2 assembly driver
// mm/dd/2024
// outputs test characters to the console using putch

.global _start // Provide program starting address

_start:

    .text  // code section

    LDR X0, =test1  // load X0 with pointer to test string
    BL putch        // call putch function
    LDR X0, =test2  // load X0 with pointer to test string
    BL putch        // call putch function
    LDR X0, =test3  // load X0 with pointer to test string
    BL putch        // call putch function
    LDR X0, =test4  // load X0 with pointer to test string
    BL putch        // call putch function
    LDR X0, =test5  // load X0 with pointer to test string
    BL putch        // call putch function

    LDR X0, =eol  // load X0 with pointer to eol string
    BL putch        // call putch function


    // terminate the program

    MOV X0, #0      // set return code to 0, all good
    MOV X8, #93     // set service code to 93 for terminate
    SVC 0           // Call Linux to terminate


    .data
test1:  .ascii   "A"
test2:  .ascii   "a"
test3:  .ascii   "!"
test4:  .ascii   "@"
test5:  .ascii   "ZZZ"
eol:    .ascii   "\n"


.end  // end of program, optional but good practice
