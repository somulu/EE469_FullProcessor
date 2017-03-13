0:      ADD,    X28, XZR, XZR   ;Set Stackpointer to 0
1:      LDURSW, X0, [X28]       ;Load A = 8 from memory location 0 into reg 0
2:      LDURSW, X1, [X28, #1]   ;Load B = 3 from memory location 1 into reg 1
3:      LDURSW, X2, [X28, #2]   ;Load C = 3 from memory location 2 into reg 2
4:      LDURSW, X3, [X28, #3]   ;Load D = 5 from memory location 3 into reg 3
5:      LDURSW, X4, [X28, #4]   ;Load E = 0x5A5A from memory location 4 into reg 4.
6:      LDURSW, X5, [X28, #5]   ;Load F = 0x6767 from memory location 5 into reg 5.
7:      LDURSW, X6, [X28, #6]   ;Load G = 0x3C from memory location 6 into reg 6.
8:      LDURSW, X7, [X28, #7]   ;Load H = 0xFF from memory location 7 into reg 7.
9:      ADDI,   X8, X28, #3     ;Put the memory address of D in register 8
10:     ADDI,   X9, XZR, #3     ;Move 3 into register 9
11:     SUB,    X10, X0, X1     ;Store the result of subtracting A-B in reg 10.
12:     SUB,    X10, X10, X9    ;Store the result of (A-B) - 3 in reg 10.
13:     B.GT,   #20             ;Go to the case where (A-B) > 3
14:     LSL,    X2, X2, #3      ;Store C << 3 in reg 2.
15:     AND,    X6, X4, X5      ;Store E & F in reg 6.
16:     STURW,  [X8], X0        ;*dPtr = 7 (memory address of D is in reg8)
17:     STURW,  [X28, #2], X2   ;C = C << 3 in memory location 2
18:     STURW,  [X28, #6], X6   ;G = E & F
19:     B,      #26             ;Go to the end of conditional
20:     ADDI,   X2, X2, #4      ;C + 4 in reg 2
21:     ORR,    X6, X4, X5      ;Store E | F in reg 6
22:     SUB,    X3, X2, X9      ;Store C - 3 in reg 3
23:     STURW,  [X28, #2], X2   ;Put X2 (C = C + 4) in memory location 2.
24:     STURW,  [X28, #6], X6   ;Put X6 (G = E | F) in memory location 6.
25:     STURW,  [X28, #3], X3   ;Put X3 (D = C - 3) in memory location 3.
26:     ADD,    X0, X0, X1      ;Store A + B in reg 0
27:     EOR,    X6, X4, X5      ;Store E ^ F in reg 1
28:     AND,    X6, X6, X7      ;Store (E^F) & H in reg 6.
29:     STURW,  [X28], X0       ;Put X0 (A = A + B) in memory location 0.
30:     STURW,  [X28, #6], X6   ;Put X6 (G = (E ^ F) & H) in memory location 6.
31:     NOP,
32:     B,      #31
