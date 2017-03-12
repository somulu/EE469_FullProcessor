0:      ADD,    X28, XZR, XZR   ;Set Stackpointer to 0
1:      ADDI,   X0, XZR, #7     ;Move 7 into reg 0
2:      ADDI,   X15,XZR, #3     ;Move 3 into reg 15
3:      ADDI,   X1, XZR, #5     ;Move 5 into reg 1
4:      ADDI,   X2, XZR, #3     ;Move 3 into reg 2
5:      ADDI,   X3, XZR, #23130 ;Put 23130 (0x5A5A) in reg 3
6:      ADDI,   X4, XZR, #26471 ;Put 26471 (0x6767) in reg 4
7:      ADDI,   X5, XZR, #60    ;Put 60 (0x3C) in reg 5
8:      ADDI,   X6, XZR, #255   ;Put 255 (0xFF) in reg 6
9:      STURW,  [X28], X0       ;Put X0 (A = 7) onto the stack at memory location 0.
a:      STURW,  [X28, #1], X15  ;Put X1 (B = 3) onto the stack at location 1.
b:      STURW,  [X28, #3], X1   ;Put X1 (D = 5) onto the stack at location 2.
c:      STURW,  [X28, #2], X2   ;Put X2 (C = 3) onto the stack at location 3.
d:      STURW,  [X28, #4], X3   ;Put X3 (E = 0x5A5A) onto the stack at location 4.
e:      STURW,  [X28, #5], X4   ;Put X4 (F = 0x6767) onto the stack at location 5.
f:      STURW,  [X28, #6], X5   ;Put X5 (G = 0x3C) onto the stack at location 6.
10:     STURW,  [X28, #7], X6   ;Put X6 (H = 0xFF) onto the stack at location 7.
11:     ADDI,   X8, XZR, #3     ;Move 3 into register 8
12:     ADDI,   X7, X28, #2     ;Put the memory address of D in register 0
13:     SUB,    X9, X0, X15     ;Store the result of subtracting A-B in reg 9.
14:     SUB,    X9, X9, X8      ;Store the result of (A-B) - 3 in reg 9.
15:     B.GT,   #28             ;Go to the case where (A-B) > 3
16:     LSL,    X2, X2, #3      ;Store C << 3 in reg 2.
17:     AND,    X5, X3, X4      ;Store E & F in reg 5.
18:     STURW,  [X7], X0        ;*dPtr = 7
19:     STURW,  [X28, #2], X2   ;C = C << 3 in memory location 2
1a:     STURW,  [X28, #6], X5   ;G = E & F
1b:     B,      #34             ;Go to the end of conditional
1c:     ADDI,   X2, X2, #4      ;C + 4 in reg 2
1d:     ORR,    X5, X3, X4      ;Store E | F in reg 5
1e:     SUB,    X11, X2, X8     ;Store C - 3 in reg 11
1f:     STURW,  [X28, #2], X2   ;Put X2 (C = C + 4) in memory location 2.
20:     STURW,  [X28, #6], X5   ;Put X5 (G = E | F) in memory location 6.
21:     STURW,  [X28, #3], X11  ;Put X11 (D = C - 3) in memory location 3.
22:     ADD,    X0, X0, X15     ;Store A - B in reg 0
23:     EOR,    X1, X3, X4      ;Store E ^ F in reg 1
24:     AND,    X1, X1, X6      ;Store (E^F) & H in reg 1.
25:     STURW,  [X28], X0       ;Put X0 (A = A + B) in memory location 0.
26:     STURW,  [X28, #6], X1   ;Put X1 (G = (E ^ F) & H) in memory location 6.
27:     NOP,
28:     B,      #39
