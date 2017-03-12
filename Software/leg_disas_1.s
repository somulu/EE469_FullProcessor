0:      ADD,    X28, XZR, XZR   ;Set Stackpointer to 0
1:      ADDI,   X0, XZR, #7     ;Move 7 into reg 0
2:      ADDI,   X1, XZR, #5     ;Move 5 into reg 1
3:      ADDI,   X2, XZR, #3     ;Move 3 into reg 2
4:      ADDI,   X3, XZR, #23130 ;Put 23130 (0x5A5A) in reg 3
5:      ADDI,   X4, XZR, #26471 ;Put 26471 (0x6767) in reg 4
6:      ADDI,   X5, XZR, #60    ;Put 60 (0x3C) in reg 5
7:      ADDI,   X6, XZR, #255   ;Put 255 (0xFF) in reg 6
8:      STURW,  [X28], X0       ;Put X0 (A = 7) onto the stack at memory location 0.
9:      STURW,  [X28, #1], X1   ;Put X1 (B = 5) onto the stack at location 1.
a:      STURW,  [X28, #3], X1   ;Put X1 (D = 5) onto the stack at location 2.
b:      STURW,  [X28, #2], X2   ;Put X2 (C = 3) onto the stack at location 3.
c:      STURW,  [X28, #4], X3   ;Put X3 (E = 0x5A5A) onto the stack at location 4.
d:      STURW,  [X28, #5], X4   ;Put X4 (F = 0x6767) onto the stack at location 5.
e:      STURW,  [X28, #6], X5   ;Put X5 (G = 0x3C) onto the stack at location 6.
f:      STURW,  [X28, #7], X6   ;Put X6 (H = 0xFF) onto the stack at location 7.
10:     ADDI,   X8, XZR, #3     ;Move 3 into register 8
11:     ADDI,   X7, X28, #2     ;Put the memory address of D in register 0
12:     SUB,    X9, X0, X1      ;Store the result of subtracting A-B in reg 9.
13:     SUB,    X9, X9, X8      ;Store the result of (A-B) - 3 in reg 9.
14:     B.GT,   #27             ;Go to the case where (A-B) > 3
15:     LSL,    X2, X2, #3      ;Store C << 3 in reg 2.
16:     AND,    X5, X3, X4      ;Store E & F in reg 5.
17:     STURW,  [X7], X0        ;*dPtr = 7
18:     STURW,  [X28, #2], X2   ;C = C << 3 in memory location 2
19:     STURW,  [X28, #6], X5   ;G = E & F
1a:     B,      #33             ;Go to the end of conditional
1b:     ADDI,   X2, X2, #4      ;C + 4 in reg 2
1c:     ORR,    X5, X3, X4      ;Store E | F in reg 5
1d:     SUB,    X11, X2, X8     ;Store C - 3 in reg 11
1e:     STURW,  [X28, #2], X2   ;Put X2 (C = C + 4) in memory location 2.
1f:     STURW,  [X28, #6], X5   ;Put X5 (G = E | F) in memory location 6.
20:     STURW,  [X28, #3], X11  ;Put X11 (D = C - 3) in memory location 3.
21:     ADD,    X0, X0, X1      ;Store A - B in reg 0
22:     EOR,    X1, X3, X4      ;Store E ^ F in reg 1
23:     AND,    X1, X1, X6      ;Store (E^F) & H in reg 1.
24:     STURW,  [X28], X0       ;Put X0 (A = A + B) in memory location 0.
25:     STURW,  [X28, #6], X1   ;Put X1 (G = (E ^ F) & H) in memory location 6.
26:     NOP,
27:     B,      #38
