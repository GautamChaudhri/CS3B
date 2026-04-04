//*****************************************************************************
// Gautam Chaudhri
// Mar 31, 2026
// lab7-3 Bubble Gum
//*****************************************************************************
// Function bubblesort: provided a valid quad integer array and its size, sorts 
//                      the array using the bubblesort alogrithm in ascending order
// INPUT:
//    * X0: pointer to first byte of valid quad integer array
//    * X1: integer indicating the size of the array
//
// OUTPUT:
//    * X0: pointer to first byte of sorted quad integer array
//*****************************************************************************
// Algorithm/Pseudocode: the following C++ code was provided and modeled for 
//                       this function
//
// void bubbleSort(long long int intAr[], const int AR_SIZE)
// {
//     long long int temp;
//     int i, j;
//     bool swapped;
// 
//     for (i = 0 ; i < AR_SIZE - 1; i++)
//     {
//         swapped = false;
//         for (j = 0; j < AR_SIZE - 1 - i; j++)
//         {
//             if (intAr[j] > intAr[j+1])
//             {
//                 temp = intAr[j];
//                 intAr[j]=intAr[j+1];
//                 intAr[j+1]= temp;
//                 swapped = true;
//             }
//         }
//         if (!swapped) break;
//     }
//     return;
// }
//*****************************************************************************

.global bubblesort
bubblesort:

  .EQU elSize, 8      // size of each element = quad = 8

  .text
  // Abort if array size is 0 or 1
  CBZ X1, outerLoopExit   // jump to termination if array size == 0
  CMP X1, #1              // compare array size with 1
  B.EQ outerLoopExit      // jump to termination if array size == 1

  // Setup outer for loop
  MOV X2, XZR           // i - counter for outer loop, set to 0
  SUB X3, X1, #1        // arraySize - 1

outerLoop:
  CMP X2, X3            // IF i >= arraySize -1
  B.GE outerLoopExit    // THEN break outer loop 

  // Reset swap variable
  MOV X4, XZR           // bool variable, 0 = no swap, 1 = swap occurred

  // Setup inner for loop
  MOV X5, XZR           // j - counter for inner loop, set to 0
  SUB X6, X3, X2        // arraySize - 1 - i

innerLoop:
  CMP X5, X6            // IF j >= arraySize - 1 - i
  B.GE innerLoopExit    // THEN break inner loop

  // Load elements j and j+1 and compare
  ADD X9, X0, X5, LSL #3  // pointer to element j
  LDR X7, [X9]            // get array[j]
  LDR X8, [X9, #elSize]!  // get array[j+1]
  CMP X7, X8              // IF array[j] <= array[j+1]
  B.LE innerLoopNext      // THEN jump around swap

  // Swap
  STR X7, [X9]            // copy array[j] to array[j+1]
  SUB X9, X9, #elSize     // X9 = j
  STR X8, [X9]            // copy array[j+1] to array[j]
  MOV X4, #1              // set swapped bool variable to true

innerLoopNext:
  ADD X5, X5, #1          // j++
  B innerLoop             // inner reloop

innerLoopExit:
  CBZ X4, outerLoopExit   // IF no swap occurred, then break outer loop
  ADD X2, X2, #1          // ELSE i++
  B outerLoop             // outer reloop

outerLoopExit:
  RET     // return
  .data
