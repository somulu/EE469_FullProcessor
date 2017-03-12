
prog_2.o:     file format elf64-littleaarch64


Disassembly of section .text:

0000000000000000 <main>:
   0:	d100c3ff 	sub	sp, sp, #0x30
   4:	52800100 	mov	w0, #0x8                   	// #8
   8:	b9002fe0 	str	w0, [sp, #44]
   c:	52800060 	mov	w0, #0x3                   	// #3
  10:	b9002be0 	str	w0, [sp, #40]
  14:	52800060 	mov	w0, #0x3                   	// #3
  18:	b90027e0 	str	w0, [sp, #36]
  1c:	528000a0 	mov	w0, #0x5                   	// #5
  20:	b90007e0 	str	w0, [sp, #4]
  24:	910013e0 	add	x0, sp, #0x4
  28:	f9000fe0 	str	x0, [sp, #24]
  2c:	528b4b40 	mov	w0, #0x5a5a                	// #23130
  30:	b90017e0 	str	w0, [sp, #20]
  34:	528cece0 	mov	w0, #0x6767                	// #26471
  38:	b90013e0 	str	w0, [sp, #16]
  3c:	52800780 	mov	w0, #0x3c                  	// #60
  40:	b9000fe0 	str	w0, [sp, #12]
  44:	52801fe0 	mov	w0, #0xff                  	// #255
  48:	b9000be0 	str	w0, [sp, #8]
  4c:	b9402fe1 	ldr	w1, [sp, #44]
  50:	b9402be0 	ldr	w0, [sp, #40]
  54:	4b000020 	sub	w0, w1, w0
  58:	71000c1f 	cmp	w0, #0x3
  5c:	5400018d 	b.le	8c <main+0x8c>
  60:	b94027e0 	ldr	w0, [sp, #36]
  64:	11001000 	add	w0, w0, #0x4
  68:	b90027e0 	str	w0, [sp, #36]
  6c:	b94027e0 	ldr	w0, [sp, #36]
  70:	51000c00 	sub	w0, w0, #0x3
  74:	b90007e0 	str	w0, [sp, #4]
  78:	b94017e1 	ldr	w1, [sp, #20]
  7c:	b94013e0 	ldr	w0, [sp, #16]
  80:	2a000020 	orr	w0, w1, w0
  84:	b9000fe0 	str	w0, [sp, #12]
  88:	1400000b 	b	b4 <main+0xb4>
  8c:	b94027e0 	ldr	w0, [sp, #36]
  90:	531d7000 	lsl	w0, w0, #3
  94:	b90027e0 	str	w0, [sp, #36]
  98:	f9400fe0 	ldr	x0, [sp, #24]
  9c:	528000e1 	mov	w1, #0x7                   	// #7
  a0:	b9000001 	str	w1, [x0]
  a4:	b94017e1 	ldr	w1, [sp, #20]
  a8:	b94013e0 	ldr	w0, [sp, #16]
  ac:	0a000020 	and	w0, w1, w0
  b0:	b9000fe0 	str	w0, [sp, #12]
  b4:	b9402fe1 	ldr	w1, [sp, #44]
  b8:	b9402be0 	ldr	w0, [sp, #40]
  bc:	0b000020 	add	w0, w1, w0
  c0:	b9002fe0 	str	w0, [sp, #44]
  c4:	b94017e1 	ldr	w1, [sp, #20]
  c8:	b94013e0 	ldr	w0, [sp, #16]
  cc:	4a000021 	eor	w1, w1, w0
  d0:	b9400be0 	ldr	w0, [sp, #8]
  d4:	0a000020 	and	w0, w1, w0
  d8:	b9000fe0 	str	w0, [sp, #12]
  dc:	d503201f 	nop
  e0:	9100c3ff 	add	sp, sp, #0x30
  e4:	d65f03c0 	ret
