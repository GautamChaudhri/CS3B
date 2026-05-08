//*****************************************************************************
// Gautam Chaudhri
// May 7, 2026
// labgve-3 Sensor Class
//*****************************************************************************
  .include "macros.s"

  // sensor struct "definition"
  .EQU Sensor.name,    0 // char*/quad name string ptr offset
  .EQU Sensor.ID,      8 // int32/word sensor ID offset
  .EQU Sensor.reading,12 // double/quad sensor reading offset
  .EQU Sensor.size,   20 // size of the struct (20 bytes)

//*****************************************************************************
// MACRO: copyStr
// INPUT:   * strSrcBuf: register containg pointer to buffer to be copied from
//          * strDestBuf: register container pointer to buffer to be copied to
//
// OUTPUT:  * VOID
//*****************************************************************************
// Algorithm:
// 1) Load current byte from source and advance pointer
// 2) Store byte to current index in destination and advance pointer
// 3) Break if current byte == null after storing
//*****************************************************************************
.macro copyStr strSrcBuf, strDestBuf
copyLoop_\@:
  LDRB    W0, [\strSrcBuf], #1    // load byte from source buffer, pointer++
  STRB    W0, [\strDestBuf], #1   // store byte to destination buffer, pointer++
  CBNZ    W0, copyLoop_\@         // IF current char != null, then reloop
.endm

  .text
//*****************************************************************************
// CONSTRUCTOR: Sensor - initializes sensor object and returns pointer to it
//
// INPUT:   * X0: const char *name
//          * X1: word ID
//          * D0: double reading
//          * X2: word struct_size
//
// OUTPUT:  * X0: Sensor* sensor
//*****************************************************************************
// Algorithm:
// 1) Get length of name string and allocate buffer for it
// 2) Copy name to newly allocated buffer
// 3) Allocate memory for entire struct
// 4) Store pointer to new name buffer, ID value, and reading value to their 
//    corresponding data members
// 5) Return pointer to struct
//*****************************************************************************
  .global Sensor
Sensor:
  PUSH1 LR            // save LR
  PUSH1 X1            // save id 
  PUSH1 D0            // save reading
  PUSH2 X0, X2        // save name and size

  // Allocate buffer for name
  BL String_length    // get length of name
  BL malloc           // allocate buffer for name
  MOV X1, X0          // move returned pointer to X1

  // Copy name to new buffer
  POP2 X2, X3         // pop name and size
  PUSH1 X1            // push pointer to newly allocated buffer
  copyStr X2, X1      // copy name to new buffer 

  // Allocate memory for sensor
  MOV X0, X3          // move sensor size to X0
  BL malloc           // allocate memory for struct
  
  // Store name, ID, and reading members
  POP1 X1                       // pop pointer to name buffer
  STR X1, [X0, #Sensor.name]    // store name buffer to name data member
  POP1 D0                       // pop reading
  POP1 X2                       // pop ID
  STR W2, [X0, #Sensor.ID]      // store ID member
  STR D0, [X0, #Sensor.reading] // store reading member 

  POP1 LR   // restore LR
  RET       // return


//*****************************************************************************
// FUNCTION: delSensor - destroys sensor struct and frees all memory
//
// INPUT:   * X0: Sensor* sensor
//
// OUTPUT:  * VOID
//*****************************************************************************
// Algorithm:
// 1) Destroy name buffer
// 2) Destroy struct 
//*****************************************************************************
  .global delSensor
delSensor:
  PUSH1 LR            // save LR

  // Destroy name buffer
  PUSH1 X0        // save pointer to struct 
  LDR X0, [X0]    // load pointer to name buffer
  BL free         // destroy name buffer

  // Destroy struct
  POP1 X0         // pop struct pointer
  BL free         // destroy struct

  POP1 LR         // restore LR
  RET             // return

//*****************************************************************************
// FUNCTION: printSensor - prints sensor name, ID, and reading
//
// INPUT:   * X0: Sensor* sensor
//
// OUTPUT:  * VOID
//*****************************************************************************
// Algorithm:
// 1) Load sensor name and print to console
// 2) Load sensor ID and print to console
// 3) Load sensor reading and print to console
//*****************************************************************************
  .global printSensor
printSensor:
  PUSH1 LR            // save LR

  // Print name
  MOV X9, X0                    // move sensor pointer to X9
  //PRINT szSensor                // print sensor message
  LDR X1, [X9, #Sensor.name]    // load name
  PRINT_STR X1                  // print sensor name
  PRINT szComma                 // print comma

  // Print ID
  LDR W0, [X9, #Sensor.ID]      // load sensor ID
  LDR X1, =idBuffer             // load buffer to hold ID as cstring
  BL int2cstr                   // convert ID to cstring
  PRINT idBuffer                // print sensor ID 
  PRINT szComma                 // print comma

  // Print reading
  LDR D0, [X9, #Sensor.reading] // load reading value
  LDR X0, =fmt                  // load printf paramteres
  BL printf                     // print sensor reading

  POP1 LR   // restore LR
  RET       //return

  .data
szSensor:   .asciz    "Sensor: "
szComma:    .asciz    ", "
idBuffer:   .skip     16
fmt:    .asciz  "%.20f\n"
