// George Eaton and Gautam Chaudhri
// CS3B - midterm assembly driver for fputstring
// 04/02/2026
// call fputstring to output a C-String to a file
//
// INPUT:
//  No input is received as parameters.
//
// OUTPUT:
//  No values are returned.
//
//  All registers except   X0, X1, X2, X3, X4, X6 and X8 are preserved

.global _start // Provide program starting address

_start:

    .EQU STDOUT,     1  // standard output file descriptor
    .EQU SYS_exit,  93  // exit() supervisor call code

    .EQU AT_FDCWD, -100 // arg0 passed to openat indicating that
                        // the filename in arg1 is relative to 
                        // the current directory

    // Linux Functions
    .EQU SYS_openFile, 56   // value for linux openat function to open files
    .EQU SYS_closeFile, 57  // value for linux close file function
    // Access Mode (flags)
    .EQU F_WRONLY, 01       // access mode set to write only
    .EQU F_CREATE, 0100     // create file if it doesnt exist
    .EQU F_TRUNC, 01000     // truncate existing file
    //File Permissions
    .EQU P_GRDWR, 0666      // global read write file permissions


    .text  // code section

    // test fputstring by outputting to the console
    LDR X0, =test1      // load X0 with pointer to test string
    MOV X1, #STDOUT     // load X1 with the standard out file descriptor
    BL fputstring       // call fputstring function.

    // Open output file
    MOV X0, #AT_FDCWD         // look for file in current directory
    LDR X1, =szOutFileName    // load buffer with filename
    MOV X2, #F_WRONLY         // load flag to open file write only
    ADD X2, X2, #F_CREATE     // add create file flag
    ADD X2, X2, #F_TRUNC      // add truncate file flag
    MOV X3, #P_GRDWR          // load global read write permissions
    MOV X8, #SYS_openFile     // load openat function value to open file
    SVC 0                     // call linux to open file

    // Call fputstring with output file fd
    MOV X6, X0                // save X0 (fd) to X6 since X1 is modified by fputstring
    MOV X1, X0                // move X0 (fd) to X1 where fputstring wants it
    LDR X0, =test1            // load string to be printed
    BL fputstring             // call fputstring function

    // Close output file
    MOV X0, X6                // restore fd to X0
    MOV X8, #SYS_closeFile    // load close function value to close file
    SVC 0                     // call linux to run close file function

    // terminate the program
    MOV X0, #0          // set return code to 0, all good
    MOV X8, #SYS_exit   // set service code to 93 for terminate
    SVC 0               // Call Linux to exit


    .data   // data section
test1:          .asciz  "CS3B rocks!\n" // test C-String
szOutFileName:  .asciz  "output.txt"    // output file name


.end  // end of program, optional but good practice
