//*****************************************************************************
// Gautam Chaudhri
// May 7, 2026
// labgve-3 - dataLT
//
// Algorithm/Pseudocode:
// 1) Set less than flag to false (0)
// 2) Load both sensor readings
// 3) If reading1 < reading2, then set less than flag to true (1)
// 4) Return
//*****************************************************************************

.global dataLT
dataLT:
  // sensor struct "definition"
  .EQU Sensor.name,    0 // char*/quad name string ptr offset
  .EQU Sensor.ID,      8 // int32/word sensor ID offset
  .EQU Sensor.reading,12 // double/quad sensor reading offset
  .EQU Sensor.size,   20 // size of the struct (20 bytes)

  .text
  MOV X9, XZR         // set less than flag to false

  // Compare readings
  LDR D0, [X0, #Sensor.reading]   // load sensor1 reading
  LDR D1, [X1, #Sensor.reading]   // load sensor2 reading
  FCMP D0, D1                     // compare reading1 and reading2
  B.GE return                     // IF reading1 >= reading2, jump to exit
  MOV X9, #1                      // ElSE reading1 < reading2, set less than flag to true

return:
  MOV X0, X9          // move less than flag to X0
  RET                 // return

  .data
