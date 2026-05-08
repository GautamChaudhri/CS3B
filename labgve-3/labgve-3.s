//*****************************************************************************
// Gautam Chaudhri
// May 7, 2026
// labgve-3 In struct or rules - driver
//
// Algorithm/Pseudocode:
// 1) Prepare and open input file
// 2) Read first 3 lines from file and build first sensor and node to initialize
//    linked list
// 3) In a loop, continue to read 3 lines at a time from inFile and do this:
//    * Build new sensor object after reading 3 lines
//    * Build new node and store sensor object
//    * Attach node to existing linked list
// 4) Break loop when attempting to read sensor name returns 0 bytes read
// 5) Traverse linked list in a loop and print it to console
// 6) Find sensors with minimum and maximum readings and print their details
//    to console
// 7) Delete min and max sensors from linked list and reprint entire list
// 8) In a loop, find node pointed to by head, delete sensor stored in node,
//    and delete the node itself. Keep looping until head points to null.
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

  // Node struct "definition"
  .EQU Node.data, 0    // quad data element offset
  .EQU Node.next, 8    // quad linked list next pointer offset
  .EQU Node.size, 16   // size of the linked list node (two quads)

  // Sensor struct "definition"
  .EQU Sensor.name,    0 // char*/quad name string ptr offset
  .EQU Sensor.ID,      8 // int32/word sensor ID offset
  .EQU Sensor.reading,12 // double/quad sensor reading offset
  .EQU Sensor.size,   20 // size of the struct (20 bytes)

  // Other constants
  .EQU DATA_BUF_SIZE, 32  // size of buffer to hold data when read from file
  .EQU STR_BUF_SIZE, 32   // size of buffer to temporarily hold sensor name 

//*****************************************************************************
// MACRO: readStr - reads a string from a file and stores it in a buffer and
//                  returns a boolean value as true if successful
// INPUT:   * fdReg: register containing a valid file descriptor
//
// OUTPUT:  * X0: bool | true (1) if something was read
//                       false (0) if nothing was read
//*****************************************************************************
// Algorithm:
// 1) Call getline with valid buffer to store output from file into buffer
// 2) If getline returns 0 bytes read, set flag to false (0), otherwise true (1)
//*****************************************************************************
.macro readStr fdReg
  MOV X0, \fdReg          // load file descriptor
  LDR X1, =strBuffer      // load buffer to hold read value
  MOV X2, #STR_BUF_SIZE   // load buffer size
  BL getline              // get value from file
  CBZ X0, setFlagTrue_\@  // IF num bytes read != 0, jump to set flag true
  MOV X0, XZR             // ELSE set flag to false (0)
  B readStrEnd_\@         // jump to end
setFlagTrue_\@:
  MOV X0, #1              // set 0 bytes read flag to true
readStrEnd_\@:
.endm

//*****************************************************************************
// MACRO: readInt - reads a number in cstring format from a file and converts
//                  it to a valid integer
// INPUT:   * fdReg: register containing a valid file descriptor
//
// OUTPUT:  * X0: valid converted integer
//*****************************************************************************
// Algorithm:
// 1) Call getline with valid buffer to store output from file into buffer
// 2) Call cstr2int with same buffer to convert cstring num into valid integer
//*****************************************************************************
.macro readInt fdReg
  MOV X0, \fdReg          // load file descriptor
  LDR X1, =dataBuffer     // load buffer to hold read value
  MOV X2, #DATA_BUF_SIZE  // load buffer size
  BL getline              // get value from file
  LDR X0, =dataBuffer     // load int as cstring
  BL cstr2int             // call function to convert data to int
readIntEnd_\@:
.endm

//*****************************************************************************
// MACRO: readDouble - reads a number in cstring format from a file and converts
//                     it to a valid double value
// INPUT:   * fdReg: register containing a valid file descriptor
//
// OUTPUT:  * D0: valid converted double
//*****************************************************************************
// Algorithm:
// 1) Call getline with valid buffer to store read value from file
// 2) Call cstr2dfp to convert cstring double to valid double
//*****************************************************************************
.macro readDouble fdReg
  MOV X0, \fdReg          // load file descriptor
  LDR X1, =dataBuffer     // load buffer to hold read value
  MOV X2, #DATA_BUF_SIZE  // load buffer size
  BL getline              // get value from file
  LDR X0, =dataBuffer     // load double as cstring
  BL cstr2dfp             // convert cstring double to valid double
.endm

//*****************************************************************************
// MACRO: buildSensor - builds a new sensor object
// INPUT:   * nameBuf: label to buffer holding name
//          * idReg: register containing sensor ID
//          * readReg: register holding double reading
//
// OUTPUT:  * X0: pointer to sensor object
//*****************************************************************************
// Algorithm:
// 1) Place all parameters into correct registers for constructor
// 2) Call sensor constructor to build object
//*****************************************************************************
.macro buildSensor nameBuf, idReg, readReg
  LDR X0, =\nameBuf       // load buffer holding name
  MOV X1, \idReg          // load ID
  FMOV D0, \readReg       // load double reading
  MOV X2, #Sensor.size    // load sensor size
  BL Sensor               // call constructor to build sensor object
.endm

//*****************************************************************************
// MACRO: delSenNode - deletes entire sensor and node objects
// INPUT:   * nodePtr: pointer to node to delete 
//
// OUTPUT:  * VOID
//*****************************************************************************
// Algorithm:
// 1) Load sensor object from node and delete sensor first
// 2) Delete node
//*****************************************************************************
.macro delSenNode nodePtr
  MOV X19, \nodePtr
  LDR X0, [X19]     // load sensor object
  BL delSensor      // delete sensor object
  LDR X0, =head     // load head
  MOV X1, X19       // move max node to X1
  BL delNode        // delete max node
.endm

//*****************************************************************************
// MACRO: printList - prints linked list
// INPUT:   * N/A (takes head value implicitly from buffer)
//
// OUTPUT:  * VOID
//*****************************************************************************
// Algorithm:
// 1) Load first node
// 2) Print current node
// 3) Advance to next node
// 4) If current node is null, break loop. If not null, reloop
//*****************************************************************************
.macro printList
  LDR X19, =head                // load head
  LDR X19, [X19]                // load address to first node
  CBZ X19, printLoopEnd_\@      // IF address == null, then skip print loop

  // Print linked list
printLoop_\@:
  LDR X0, [X19]                 // load sensor object from current node
  BL printSensor                // call function to print sensor obj
  LDR X19, [X19, #Node.next]    // load next node
  CBZ X19, printLoopEnd_\@      // IF address == null, then break loop
  B printLoop_\@                // ELSE reloop
printLoopEnd_\@:
.endm


  .text
  PUSH1 X19           // save register for later use

  // Open input file
  MOV X4, #F_RDONLY   // load read only access mode
  MOV X5, #P_RDWR     // load file permissions
  OPEN_FILE inFile, X4, X5, X9, terminate // open inFile, save fd in X9

  // Read file and build sensor object
  readStr X9              // read name from file
  readInt X9              // read ID from file
  MOV X10, X0             // move ID to X10
  readDouble X9           // read sensor reading from file
  buildSensor strBuffer, X10, D0

  // Create linked list with first node
  BL Node                 // store sensor obj in node
  MOV X1, X0              // move pointer to new node to X1
  LDR X0, =head           // load head
  BL addNode              // create linked list with first node

  // Traverse inFile building sensor objects and adding them to linked list
buildListLoop:
  // Build sensor object
  readStr X9              // read name from file
  CBNZ X0, buildListExit  // exit loop if 0 bytes read
  readInt X9              // read ID from file
  MOV X10, X0             // move ID to X10
  readDouble X9           // read sensor reading from file
  buildSensor strBuffer, X10, D0

  // Build node
  BL Node                 // store sensor obj in node
  MOV X1, X0              // move pointer to new node to X1
  LDR X0, =head           // load head
  BL addNode              // create linked list with first node
  B buildListLoop         // reloop

  // Print list
buildListExit:
  printList

  // Find and print sensor with lowest reading
  PRINT_EOL                     // print newline
  PRINT szLowRead               // print high reading message
  LDR X0, =head                 // load head
  LDR X0, [X0]                  // load first node
  BL findMinNode                // find max node
  PUSH1 X0                      // save pointer to max node
  LDR X0, [X0]                  // load max sensor from node
  BL printSensor                // print max sensor

  // Find and print sensor with highest reading
  PRINT szHighRead              // print high reading message
  LDR X0, =head                 // load head
  LDR X0, [X0]                  // load first node
  BL findMaxNode                // find max node
  PUSH1 X0                      // save pointer to min node
  LDR X0, [X0]                  // load max sensor from node
  BL printSensor                // print max sensor
  PRINT_EOL                     // print newline
  PRINT_EOL                     // print newline

  // Delete min and max nodes
  POP1 X19          // pop max node
  delSenNode X19    // del sensor and node with max reading
  POP1 X19          // pop min node
  delSenNode X19    // del sensor and node with min reading   

  // Reprint list
  printList         // print list

  // Find and print sensor with lowest reading
  PRINT_EOL                     // print newline
  PRINT szLowRead               // print high reading message
  LDR X0, =head                 // load head
  LDR X0, [X0]                  // load first node
  BL findMinNode                // find max node
  PUSH1 X0                      // save pointer to max node
  LDR X0, [X0]                  // load max sensor from node
  BL printSensor                // print max sensor

  // Find and print sensor with highest reading
  PRINT szHighRead              // print high reading message
  LDR X0, =head                 // load head
  LDR X0, [X0]                  // load first node
  BL findMaxNode                // find max node
  PUSH1 X0                      // save pointer to min node
  LDR X0, [X0]                  // load max sensor from node
  BL printSensor                // print max sensor

  // Delete linked list
delListLoop:
  LDR X0, =head                 // load head
  LDR X1, [X0]                  // load first node pointed to by head
  CBZ X1, terminate             // IF head == NULL, list is empty, exit loop
  delSenNode X1                 // ELSE call delNode to delete the node pointed to by head
  B delListLoop                 // reloop

terminate:
  POP1 X19                      // restore X19
  MOV X0, #0          // use 0 for return code success
  MOV X8, #SYS_exit   // service code to exit
  SVC 0               // call linux to exit 

  .data
// linked list variables
head: .quad 0        // pointer to the head of the linked list

inFile:     .asciz    "gve-3input.txt"
dataBuffer: .skip     DATA_BUF_SIZE
strBuffer:  .skip     STR_BUF_SIZE

szHighRead: .asciz    "Highest Reading : "
szLowRead: .asciz    "Lowest Reading  : "
