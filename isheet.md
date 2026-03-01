# ARM64 Assembly Reference

---

## Instructions

### Data Movement

| Instruction | Description |
|-------------|-------------|
| `MOV` | Overwrite whole register |
| `MOVK` | Move keep — overwrites partial register |
| `MOVN` | Move not — inverts value before loading |

### Shifts & Extends

| Instruction | Description |
|-------------|-------------|
| `LSL` | Logical shift left — move bits left |
| `LSR` | Logical shift right — move bits right |
| `ASR` | Arithmetic shift right — move bits right, retain sign |
| `ROR` | Rotate right — fallen-off bits loop back to left |
| `UXTB` | Unsigned extend byte — extract byte, zero-extend |
| `UXTH` | Unsigned extend halfword |
| `UXTW` | Unsigned extend word |
| `SXTB` | Signed extend byte — extract byte, sign-extend |
| `SXTH` | Signed extend halfword |
| `SXTW` | Signed extend word |

### Arithmetic

| Instruction | Description |
|-------------|-------------|
| `ADD` | Add two registers |
| `ADDS` | Add and set flags |
| `SUB` | Subtract |
| `SUBS` | Subtract and set flags |
| `SDIV` | Signed division |
| `UDIV` | Unsigned division |
| `MUL` | Multiply |
| `CMP` | Compare — computes `Xn - Operand2`, sets flags only |

---

## Load / Store

| Instruction | Description |
|-------------|-------------|
| `LDR` | Load register (8 bytes) |
| `LDRB` | Load single byte |
| `LDRH` | Load halfword |
| `LDRSB` | Load signed byte |
| `LDRSH` | Load signed halfword |
| `STR` | Store register |
| `STRB` | Store byte |

### Addressing Modes

```asm
LDR X0, =myVar          ; load address of myVar into X0
LDR X1, [X0]            ; load 8 bytes from address in X0
LDR X1, [X0, #8]        ; load from X0 + 8 (immediate offset)
LDR X1, [X0, X2]        ; load from X0 + X2 (register offset)
LDRB W1, [X0]           ; load 1 byte from address in X0
LDRB W1, [X0, #3]       ; load 1 byte from X0 + 3

STR X1, [X0]            ; store 8 bytes from X1 to address in X0
STR X1, [X0, #8]        ; store to X0 + 8 (immediate offset)
STRB W1, [X0]           ; store 1 byte from W1 to address in X0
STRB W1, [X0, X2]       ; store 1 byte to X0 + X2 (register offset)

LDR X1, [X0], #8        ; post-index: load from X0, then X0 += 8
LDR X1, [X0, #8]!       ; pre-index:  X0 += 8, then load from X0
```

---

## Branch

| Instruction | Condition | Flags |
|-------------|-----------|-------|
| `B` | Unconditional jump | — |
| `BL` | Branch with link | — |
| `B.EQ` | Equal | Z set |
| `B.NE` | Not equal | Z clear |
| `B.MI` | Minus / negative | N set |
| `B.PL` | Plus / positive | N clear |
| `B.VS` | Overflow occurred | V set |
| `B.VC` | No overflow | V clear |
| `B.GE` | Greater than or equal | N and V same |
| `B.LT` | Less than | N and V differ |
| `B.GT` | Greater than | Z clear, N and V same |
| `B.LE` | Less than or equal | Z set, N and V differ |
| `B.AL` | Always | — |
| `CBZ` | Jump if register = 0 | — |
| `CBNZ` | Jump if register ≠ 0 | — |
| `RET` | Return to address in `LR`/`X30` | — |

---

## System

| Instruction | Description |
|-------------|-------------|
| `SVC` | Supervisor call (system call) |
| `NOP` | No operation |

---

## Linux System Calls (ARM64)

> `X8` = syscall number &nbsp;|&nbsp; `X0`–`X5` = arguments &nbsp;|&nbsp; `X0` = return value

| Number | Call | Arguments |
|--------|------|-----------|
| `63` | `read` | `X0` = fd, `X1` = buf, `X2` = count |
| `64` | `write` | `X0` = fd, `X1` = buf, `X2` = count |
| `93` | `exit` | `X0` = exit code |

---

## GDB Commands

### Breakpoints

| Command | Description |
|---------|-------------|
| `b <location>` | Set breakpoint |
| `i b` | List breakpoints |
| `d <n>` | Delete breakpoint n |
| `d` | Delete all breakpoints |

### Execution

| Command | Description |
|---------|-------------|
| `c` | Continue execution |
| `s` | Step one source line |
| `si` | Step one instruction |
| `n` | Step over function |
| `ni` | Next instruction |

### Viewing Code

| Command | Description |
|---------|-------------|
| `l` | List source code |
| `disas` | Show disassembly |

### Examining Registers

| Command | Description |
|---------|-------------|
| `i r` | Show all registers |
| `i r x0` | Show specific register |
| `p $x0` | Print register value |
| `p/x $x0` | Print in hex |
| `p/t $x0` | Print in binary |
| `p/d $x0` | Print in decimal |
| `display $x0` | Auto-display after each step |
| `undisplay <n>` | Stop auto-displaying |

### Examining Memory — `x/[count][format][size] <addr>`

**Format:**

| Flag | Meaning |
|------|---------|
| `x` | Hex |
| `d` | Signed decimal |
| `u` | Unsigned decimal |
| `t` | Binary |
| `i` | Instruction |
| `c` | Char |
| `s` | Null-terminated string |

**Size:**

| Flag | Meaning |
|------|---------|
| `b` | Byte (1 byte) |
| `h` | Halfword (2 bytes) |
| `w` | Word (4 bytes) |
| `g` | Giant / quad (8 bytes) |

**Examples:**

```gdb
x/1ub  &bA         ; 1 byte, unsigned decimal
x/1cb  &chInit     ; 1 byte as char
x/1uh  &u16Hi      ; 1 halfword, unsigned decimal
x/1dw  &wAlt       ; 1 word, signed decimal
x/1dw  &wAlt+4     ; 1 word at +4 byte offset
x/1xg  &dbBig      ; 1 quad in hex
x/s    &szMsg1     ; null-terminated string
x/4xb  &var        ; 4 bytes in hex
x/8i   $pc         ; 8 instructions at program counter
```

### Misc

```gdb
&variable     ; get address of a variable
$register     ; get contents of a register
info variables ; list all variables
```