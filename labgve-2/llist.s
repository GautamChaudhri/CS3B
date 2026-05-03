//*****************************************************************************
// Gautam Chaudhri
// May 1, 2026
// labgve-2 Link Me - linked list class
//*****************************************************************************
  .include "macros.s"

  // linked list Node "struct definition"
  .EQU Node.data, 0    // quad data element offset
  .EQU Node.next, 8    // quad linked list next pointer offset
  .EQU Node.size, 16   // size of the linked list node (two quads)

  .text
//*****************************************************************************
// CONSTRUCTOR: Node - creates a Node and sets data element to data, next to null
// INPUT:   * X0: quad data
//
// OUTPUT:  * X0: Node* node
//*****************************************************************************
// Algorithm:
// 1) Allocate memory for 1 node
// 2) Store data into data member and null into next member
//*****************************************************************************
.global Node
Node:
  MOV X1, X0                // move data to X1
  PUSH2 LR, X1              // save LR and data
  MOV X0, #Node.size        // load node size
  BL malloc                 // allocate 1 node
  POP2 LR, X1               // restore LR and data
  STR X1, [X0]              // store data in Node.data
  STR XZR, [X0, #Node.next] // store null in Node.next
  RET                       // return


//*****************************************************************************
// FUNCTION: addNode - adds Node node to front/head of linked-list, returns 
//                     updated head
// INPUT:   * X0: Node* head
//          * X1: Node* node
//
// OUTPUT:  * X0: Node* head
//*****************************************************************************
// Algorithm:
// 1) Get address of node pointed to by head
// 2) Make given node point to same node as head
// 3) Make head point to given node
//*****************************************************************************
.global addNode
addNode:
  LDR X2, [X0]              // get address of node pointed to by head
  STR X2, [X1, #Node.next]  // store address in given node.next
  STR X1, [X0]              // store given node address in head
  RET                       // return


//*****************************************************************************
// FUNCTION: delNode - deletes Node node, returns head, updated if applicable
// INPUT:   * X0: Node* head
//          * X1: Node* node
//
// OUTPUT:  * X0: Node* head
//*****************************************************************************
// Algorithm:
// 1) Check if target node is in head. If so, update head and return.
// 2) Otherwise, traverse list in a loop until the node before the target node
//    is found
// 3) Set previous node's next to target node's next
// 4) Delete target node by freeing its memory
//*****************************************************************************
.global delNode
delNode:
  PUSH2 X0, LR              // save &head and LR
  LDR X2, [X0]              // load head node into X2, keep X0 = &head

  // Handle head case: if head node == target node
  CMP X2, X1                // compare head node with target node
  B.NE searchSetup          // IF head != target node, go to normal search
  LDR X3, [X1, #Node.next]  // ELSE load target->next
  STR X3, [X0]              // store new head directly into head variable
  B freeTarget              // skip patching, go free the node

  // Find predecessor of target node
searchSetup:
  MOV X0, X2                // start current node at head node
searchLoop:
  LDR X2, [X0, #Node.next]  // load current->next
  CMP X2, X1                // compare current->next with target node
  B.EQ patchLink            // IF current->next == target, found predecessor
  MOV X0, X2                // ELSE advance, current = current->next
  B searchLoop              // and reloop

  // Patch linked list and delete target node
patchLink:
  LDR X3, [X1, #Node.next]  // load target->next
  STR X3, [X0, #Node.next]  // store target's next into previous node's next, bypassing target

  // Delete target node
freeTarget:
  MOV X0, X1                // move target node to X0 for free()
  BL free                   // delete target node
  POP2 X0, LR               // restore &head and LR
  RET                       // return


//*****************************************************************************
// FUNCTION: findMinNode - finds Node with minimum data value using helper dataLT
// INPUT:   * X0: Node* head
//
// OUTPUT:  * X0: Node* node
//*****************************************************************************
// Algorithm:
// 1) Save head as initial min node
// 2) Traverse linked list in a loop, comparing each nodes data value to
//    currently marked min node's data value
// 3) If new min node found update it
// 4) Break loop when current node is null
//*****************************************************************************
.global findMinNode
findMinNode:
  PUSH1 LR                  // save LR

  // Basic setup
  MOV X3, X0                // save head node as current min node
  LDR X4, [X0, #Node.next]  // load second node as current node

  // Traverse linked list to find min node
minLoop:
  CMP X4, XZR               // check if current node is NULL
  B.EQ minExit              // IF NULL, we are done walking the list

  LDR X0, [X3, #Node.data]  // load min node's data as data1
  LDR X1, [X4, #Node.data]  // load current node's data as data2
  BL dataLT                 // call dataLT(min.data, current.data)
  CBNZ X0, minNext          // IF min.data < current.data, min stays, advance
  MOV X3, X4                // ELSE current.data <= min.data, update min node

  // Current node is not min, so advance
minNext:
  LDR X4, [X4, #Node.next]  // load next node
  B minLoop                 // reloop

minExit:
  MOV X0, X3                // move min node to X0 for return
  POP1 LR                   // restore LR
  RET                       // return


//*****************************************************************************
// FUNCTION: findMaxNode - finds Node with maximum data value using helper dataLT
// INPUT:   * X0: Node* head
//
// OUTPUT:  * X0: Node* node
//*****************************************************************************
// Algorithm:
// 1) Save head as initial max node
// 2) Traverse linked list in a loop, comparing each nodes data value to
//    currently marked max node's data value
// 3) If new max node found update it
// 4) Break loop when current node is null
//*****************************************************************************
.global findMaxNode
findMaxNode:
  PUSH1 LR                  // save LR

  // Basic setup
  MOV X3, X0                // save head node as current max node
  LDR X4, [X0, #Node.next]  // load second node as current node

  // Traverse linked list to find max node
maxLoop:
  CMP X4, XZR               // check if current node is NULL
  B.EQ maxExit              // IF NULL, we are done walking the list

  LDR X0, [X4, #Node.data]  // load current node's data as data1
  LDR X1, [X3, #Node.data]  // load max node's data as data2
  BL dataLT                 // call dataLT(current.data, max.data)
  CBNZ X0, maxNext          // IF current.data < max.data, max stays, advance
  MOV X3, X4                // ELSE current.data >= max.data, update max node

  // Current node is not max, so advance
maxNext:
  LDR X4, [X4, #Node.next]  // load next node
  B maxLoop                 // reloop

maxExit:
  MOV X0, X3                // move max node to X0 for return
  POP1 LR                   // restore LR
  RET                       // return

.data
