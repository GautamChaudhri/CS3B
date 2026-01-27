// Gautam Chaudhri
// CS3B - lab1-1 - Hello CS3B
// 1/16/2026
// Assembler program to print "Hello CS3B!" to stdout.
// Algorithm/Pseudocode:
//      Output: Prints "Hello CS3B!" to stdout

// X0-X2 - parameters to Linux function services
// X8 - Linux function number

// Provide program starting address and then call Linux to do it
.global _start
_start: MOV X0, #1          // 1 = Stdout
    LDR X1, =szHelloCS3B    // string to print
    MOV X2, #12             // length of string to print
    MOV     X8, #64         // Linux write system call
    SVC 0                   // Call Linux to output the string

// Setup parameters to exit the program and then call Linux to do it
    MOV     X0, #0          // Use 0 return code
    MOV X8, #93             // Service code 93 to terminate
    SVC 0                   // Call Linux to terminate

    .data                   // Data section
    szHelloCS3B:  .ascii  "Hello CS3B!\n"   //String to print to stdout
