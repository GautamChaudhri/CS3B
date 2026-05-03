//*****************************************************************************
// Gautam Chaudhri
// May 1, 2026
// labgve-2 Link Me - driver
//
// Algorithm/Pseudocode:
// 1) Open and prepare input file
// 2) In a loop, read data from file, build new node containing that data,
//    and add node to existing linked list
//    * Build the first node outside of the loop so there is an existing linked
//      list to add all of the next nodes too
//    * Break loop when no bytes read from file
// 3) In a loop, traverse linked list, grabbing data from each node and printing
//    it to the console
//    * Break when address of current node is null
// 4) Find node with minimum data value from linked list and delete it
// 5) Find node with maximum data value from linked list and delete it
// 6) Repeat step 3 to print revised linked list again
// 7) In a loop, call delNode function repeatedly, passing it the address of the
//    of the node pointed to by head to delete
//    * Break when head is pointing to null
//*****************************************************************************

.global _start
_start:
  .include "macros.s"

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

  // labgve-2 aliases
  .EQU DATA_BUF_SIZE, 8
  .EQU Node.data, 0    // quad data element offset
  .EQU Node.next, 8    // quad linked list next pointer offset
  .EQU Node.size, 16   // size of the linked list node (two quads)

//*****************************************************************************
// MACRO: readNum - reads a number in cstring format from a file and converts
//                  it to a valid integer and provides a boolean indicating
//                  if a value was read from the file or not
// INPUT:   * fdReg: register containing a valid file descriptor
//
// OUTPUT:  * X0: valid converted integer
//          * X1: 0 bytes read flag | 1 == true (0 bytes read), 0 = false
//*****************************************************************************
// Algorithm:
// 1) Call getline with valid buffer to store output from file into buffer
//    * IF getline returns 0 bytes read, set flag and jump to end of macro
// 2) Call cstr2int with same buffer to convert cstring num into valid integer
//*****************************************************************************
.macro readNum fdReg
  MOV X0, \fdReg          // load file descriptor
  LDR X1, =dataBuffer     // load buffer to hold read value
  MOV X2, #DATA_BUF_SIZE  // load buffer size
  BL getline              // get value from file
  CBNZ X0, readNumNext_\@ // IF num bytes read != 0, jump around setting flag
  MOV X1, #1              // ELSE set 0 bytes read flag to true (1)
  B readNumEnd_\@         // jump to end
readNumNext_\@:
  LDR X0, =dataBuffer     // load dataBuffer
  BL cstr2int             // call function to convert data to int
  MOV X1, XZR             // set 0 bytes read flag to false (0)
readNumEnd_\@:
.endm

//*****************************************************************************
// MACRO: printNodeData - when given the address to a valid node in a linked
//                        list, it converts the data member into a valid cstring
//                        and prints that value to the console
// INPUT:   * nodeReg: register containing valid memory address of existing node
//
// OUTPUT:  * the node's data member is printed to the console
//*****************************************************************************
// Algorithm:
// 1) Load value stored in data member of node
// 2) Call int2cstr with buffer to convert data into valid cstring
// 3) Print converted cstring to console
//*****************************************************************************
.macro printNodeData nodeReg
  MOV X0, \nodeReg        // move node address to X0
  LDR X0, [X0]            // load data member from node
  LDR X1, =dataBuffer     // load dataBuffer to hold cstring 
  BL int2cstr             // call function to convert to cstring
  PRINT dataBuffer        // print data to console
  PRINT_EOL               // print newline
.endm

  .text
  // Open input file
  MOV X4, #F_RDONLY   // load read only access mode
  MOV X5, #P_RDWR     // load file permissions
  OPEN_FILE inFile, X4, X5, X9, delListExit   // open inFile, save fd in X9

  // Build first node outside of loop to initialize head
  readNum X9              // read current value from inFile
  CBNZ X1, buildListExit  // IF no bytes read flag is true, abort
  BL Node                 // ELSE build node with data value
  LDR X1, =head           // load head
  STR X0, [X1]            // make head point to newly created node

  // Traverse inFile and build linked list
buildListLoop:
  readNum X9              // read current value from inFile
  CBNZ X1, buildListExit  // IF no bytes read flag is true, exit loop
  BL Node                 // ELSE build node with data value
  MOV X1, X0              // move new node address to X1
  LDR X0, =head           // load head
  BL addNode              // add new node to linked list
  B buildListLoop         // reloop

  // Prepare first node to be printed
buildListExit:
  LDR X10, =head          // load head
  LDR X10, [X10]          // load address to first node
  CBZ X10, printLoopExit1 // IF address == null, then skip print loop

  // Traverse linked list, printing each data value to console
printLoop1:
  printNodeData X10             // print current node data
  LDR X10, [X10, #Node.next]    // load next node
  CBZ X10, printLoopExit1       // IF address == null, then break loop
  B printLoop1                  // ELSE reloop

  // Find min node and delete it
printLoopExit1:
  LDR X0, =head                 // load head
  LDR X0, [X0]                  // load actual head
  BL findMinNode                // call function to find min node
  MOV X1, X0                    // load min node into X1
  LDR X0, =head                 // load head again
  BL delNode                    // delete min node

  // Find max node and delete it
  LDR X0, =head                 // load head
  LDR X0, [X0]                  // load actual head
  BL findMaxNode                // call function to find max node
  MOV X1, X0                    // load max node into X1
  LDR X0, =head                 // load head again
  BL delNode                    // delete max node

  // Add spacing between next print
  PRINT_EOL
  PRINT_EOL

  // Traverse linked list, printing each data value to console
  LDR X10, =head                // load head
  LDR X10, [X10]                // load address to first node
  CBZ X10, printLoopExit2       // IF address == null, then skip print loop
printLoop2:
  printNodeData X10             // print current node data
  LDR X10, [X10, #Node.next]    // load next node
  CBZ X10, printLoopExit2       // IF address == null, then break loop
  B printLoop2                  // ELSE reloop

printLoopExit2:
delListLoop:
  LDR X0, =head             // load head
  LDR X1, [X0]              // load first node pointed to by head
  CBZ X1, delListExit      // IF head == NULL, list is empty, exit loop
  BL delNode                // ELSE call delNode to delete the node pointed to by head
  B delListLoop            // reloop

  // Prepare to terminate
delListExit:
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call linux to exit 

  .data
// linked list variables
head: .quad 0        // pointer to the head of the linked list

inFile:     .asciz    "gve-2input.txt"
dataBuffer: .skip     DATA_BUF_SIZE
