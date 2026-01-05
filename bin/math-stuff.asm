;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.module math_stuff
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _draw_line
	.globl _clear_screen
	.globl _fs_count
	.globl _fs_len
	.globl _fs
	.globl _face3
	.globl _face2
	.globl _face1
	.globl _face0
	.globl _vs_count
	.globl _vs
	.globl _frame
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_dz:
	.ds 2
_angle:
	.ds 2
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _TEXT
;src/math-stuff.c:81: static inline q8_8_t fmul(q8_8_t a, q8_8_t b) {
;	---------------------------------
; Function fmul
; ---------------------------------
_fmul:
;src/math-stuff.c:82: return (q8_8_t)(((q32_t)a * (q32_t)b) >> FP_SHIFT);
	call	___mulsint2slong
	ld	e, d
	ld	d, l
;src/math-stuff.c:83: }
	ret
_vs:
	.dw #0x0000
	.dw #0x0100
	.dw #0x0000
	.dw #0xff01
	.dw #0xff00
	.dw #0xff00
	.dw #0x00ff
	.dw #0xff00
	.dw #0xff00
	.dw #0xff01
	.dw #0xff00
	.dw #0x0100
	.dw #0x00ff
	.dw #0xff00
	.dw #0x0100
_vs_count:
	.dw #0x0005
_face0:
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x00	; 0
_face1:
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x00	; 0
_face2:
	.db #0x02	; 2
	.db #0x04	; 4
	.db #0x00	; 0
_face3:
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x00	; 0
_fs:
	.dw _face0
	.dw _face1
	.dw _face2
	.dw _face3
_fs_len:
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
_fs_count:
	.dw #0x0007
;src/math-stuff.c:85: static inline q8_8_t fdiv(q8_8_t a, q8_8_t b) {
;	---------------------------------
; Function fdiv
; ---------------------------------
_fdiv:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	ex	(sp), hl
	ld	c, e
	ld	b, d
;src/math-stuff.c:86: if (b == 0) return (a >= 0) ? INT16_MAX : INT16_MIN;
	ld	a, b
	or	a, c
	jr	NZ, 00102$
	pop	bc
	push	bc
	bit	7, b
	jr	NZ, 00105$
	ld	de, #0x7fff
	jr	00103$
00105$:
	ld	de, #0x8000
	jr	00103$
00102$:
;src/math-stuff.c:87: return (q8_8_t)(((q32_t)a << FP_SHIFT) / (q32_t)b);
	ld	e, -2 (ix)
	ld	a, -1 (ix)
	ld	d, a
	rlca
	sbc	hl, hl
	ld	h, l
;	spillPairReg hl
;	spillPairReg hl
	ld	l, d
;	spillPairReg hl
;	spillPairReg hl
	ld	d, e
	ld	e, #0x00
	ld	a, b
	rlca
	sbc	a, a
	push	iy
	ld	-4 (ix), a
	ld	-3 (ix), a
	push	bc
	call	__divslong
	pop	af
	pop	af
00103$:
;src/math-stuff.c:88: }
	ld	sp, ix
	pop	ix
	ret
;src/math-stuff.c:140: static void lut_rot(uint8_t a, q8_8_t *out_cos, q8_8_t *out_sin) {
;	---------------------------------
; Function lut_rot
; ---------------------------------
_lut_rot:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	ld	c, a
	inc	sp
	inc	sp
	push	de
;src/math-stuff.c:141: *out_cos = cos_lut[a]; // Q8.8
	ld	hl, #_cos_lut+0
	ld	e, c
	ld	d, #0x00
	ex	de, hl
	add	hl, hl
	ex	de, hl
	add	hl, de
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	pop	hl
	push	hl
	ld	(hl), c
	inc	hl
	ld	(hl), b
;src/math-stuff.c:142: *out_sin = sin_lut[a]; // Q8.8
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	ld	hl, #_sin_lut+0
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;src/math-stuff.c:143: }
	ld	sp, ix
	pop	ix
	pop	hl
	pop	af
	jp	(hl)
_ANGLE_STEP:
	.db #0x04	; 4
_sin_lut:
	.dw #0x0000
	.dw #0x0003
	.dw #0x0006
	.dw #0x0009
	.dw #0x000c
	.dw #0x0010
	.dw #0x0013
	.dw #0x0016
	.dw #0x0019
	.dw #0x001c
	.dw #0x001f
	.dw #0x0022
	.dw #0x0025
	.dw #0x0028
	.dw #0x002b
	.dw #0x002e
	.dw #0x0031
	.dw #0x0034
	.dw #0x0037
	.dw #0x003a
	.dw #0x003d
	.dw #0x0040
	.dw #0x0043
	.dw #0x0046
	.dw #0x0049
	.dw #0x004c
	.dw #0x004e
	.dw #0x0051
	.dw #0x0054
	.dw #0x0057
	.dw #0x005a
	.dw #0x005d
	.dw #0x005f
	.dw #0x0062
	.dw #0x0065
	.dw #0x0068
	.dw #0x006a
	.dw #0x006d
	.dw #0x006f
	.dw #0x0072
	.dw #0x0074
	.dw #0x0077
	.dw #0x0079
	.dw #0x007c
	.dw #0x007e
	.dw #0x0080
	.dw #0x0083
	.dw #0x0085
	.dw #0x0087
	.dw #0x008a
	.dw #0x008c
	.dw #0x008e
	.dw #0x0090
	.dw #0x0093
	.dw #0x0095
	.dw #0x0097
	.dw #0x0099
	.dw #0x009b
	.dw #0x009d
	.dw #0x009f
	.dw #0x00a1
	.dw #0x00a3
	.dw #0x00a5
	.dw #0x00a7
	.dw #0x00a9
	.dw #0x00ab
	.dw #0x00ad
	.dw #0x00af
	.dw #0x00b1
	.dw #0x00b2
	.dw #0x00b4
	.dw #0x00b6
	.dw #0x00b8
	.dw #0x00b9
	.dw #0x00bb
	.dw #0x00bd
	.dw #0x00be
	.dw #0x00c0
	.dw #0x00c2
	.dw #0x00c3
	.dw #0x00c5
	.dw #0x00c6
	.dw #0x00c8
	.dw #0x00c9
	.dw #0x00cb
	.dw #0x00cc
	.dw #0x00ce
	.dw #0x00cf
	.dw #0x00d0
	.dw #0x00d2
	.dw #0x00d3
	.dw #0x00d4
	.dw #0x00d6
	.dw #0x00d7
	.dw #0x00d8
	.dw #0x00da
	.dw #0x00db
	.dw #0x00dc
	.dw #0x00dd
	.dw #0x00df
	.dw #0x00e0
	.dw #0x00e1
	.dw #0x00e2
	.dw #0x00e3
	.dw #0x00e4
	.dw #0x00e5
	.dw #0x00e7
	.dw #0x00e8
	.dw #0x00e9
	.dw #0x00ea
	.dw #0x00ea
	.dw #0x00eb
	.dw #0x00ec
	.dw #0x00ed
	.dw #0x00ee
	.dw #0x00ef
	.dw #0x00f0
	.dw #0x00f1
	.dw #0x00f1
	.dw #0x00f2
	.dw #0x00f3
	.dw #0x00f3
	.dw #0x00f4
	.dw #0x00f5
	.dw #0x00f5
	.dw #0x00f6
	.dw #0x00f6
	.dw #0x00f7
	.dw #0x00f7
	.dw #0x00f8
	.dw #0x00f8
	.dw #0x00f9
	.dw #0x00f9
	.dw #0x00fa
	.dw #0x00fa
	.dw #0x00fa
	.dw #0x00fb
	.dw #0x00fb
	.dw #0x00fb
	.dw #0x00fc
	.dw #0x00fc
	.dw #0x00fc
	.dw #0x00fc
	.dw #0x00fd
	.dw #0x00fd
	.dw #0x00fd
	.dw #0x00fd
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fd
	.dw #0x00fd
	.dw #0x00fd
	.dw #0x00fd
	.dw #0x00fc
	.dw #0x00fc
	.dw #0x00fc
	.dw #0x00fc
	.dw #0x00fb
	.dw #0x00fb
	.dw #0x00fb
	.dw #0x00fa
	.dw #0x00fa
	.dw #0x00fa
	.dw #0x00f9
	.dw #0x00f9
	.dw #0x00f8
	.dw #0x00f8
	.dw #0x00f7
	.dw #0x00f7
	.dw #0x00f6
	.dw #0x00f6
	.dw #0x00f5
	.dw #0x00f5
	.dw #0x00f4
	.dw #0x00f3
	.dw #0x00f3
	.dw #0x00f2
	.dw #0x00f1
	.dw #0x00f1
	.dw #0x00f0
	.dw #0x00ef
	.dw #0x00ee
	.dw #0x00ed
	.dw #0x00ec
	.dw #0x00eb
	.dw #0x00ea
	.dw #0x00ea
	.dw #0x00e9
	.dw #0x00e8
	.dw #0x00e7
	.dw #0x00e5
	.dw #0x00e4
	.dw #0x00e3
	.dw #0x00e2
	.dw #0x00e1
	.dw #0x00e0
	.dw #0x00df
	.dw #0x00dd
	.dw #0x00dc
	.dw #0x00db
	.dw #0x00da
	.dw #0x00d8
	.dw #0x00d7
	.dw #0x00d6
	.dw #0x00d4
	.dw #0x00d3
	.dw #0x00d2
	.dw #0x00d0
	.dw #0x00cf
	.dw #0x00ce
	.dw #0x00cc
	.dw #0x00cb
	.dw #0x00c9
	.dw #0x00c8
	.dw #0x00c6
	.dw #0x00c5
	.dw #0x00c3
	.dw #0x00c2
	.dw #0x00c0
	.dw #0x00be
	.dw #0x00bd
	.dw #0x00bb
_cos_lut:
	.dw #0x0100
	.dw #0x0100
	.dw #0x0100
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00ff
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fe
	.dw #0x00fd
	.dw #0x00fd
	.dw #0x00fd
	.dw #0x00fd
	.dw #0x00fc
	.dw #0x00fc
	.dw #0x00fc
	.dw #0x00fc
	.dw #0x00fb
	.dw #0x00fb
	.dw #0x00fb
	.dw #0x00fa
	.dw #0x00fa
	.dw #0x00fa
	.dw #0x00f9
	.dw #0x00f9
	.dw #0x00f8
	.dw #0x00f8
	.dw #0x00f7
	.dw #0x00f7
	.dw #0x00f6
	.dw #0x00f6
	.dw #0x00f5
	.dw #0x00f5
	.dw #0x00f4
	.dw #0x00f3
	.dw #0x00f3
	.dw #0x00f2
	.dw #0x00f1
	.dw #0x00f1
	.dw #0x00f0
	.dw #0x00ef
	.dw #0x00ee
	.dw #0x00ed
	.dw #0x00ec
	.dw #0x00eb
	.dw #0x00ea
	.dw #0x00ea
	.dw #0x00e9
	.dw #0x00e8
	.dw #0x00e7
	.dw #0x00e5
	.dw #0x00e4
	.dw #0x00e3
	.dw #0x00e2
	.dw #0x00e1
	.dw #0x00e0
	.dw #0x00df
	.dw #0x00dd
	.dw #0x00dc
	.dw #0x00db
	.dw #0x00da
	.dw #0x00d8
	.dw #0x00d7
	.dw #0x00d6
	.dw #0x00d4
	.dw #0x00d3
	.dw #0x00d2
	.dw #0x00d0
	.dw #0x00cf
	.dw #0x00ce
	.dw #0x00cc
	.dw #0x00cb
	.dw #0x00c9
	.dw #0x00c8
	.dw #0x00c6
	.dw #0x00c5
	.dw #0x00c3
	.dw #0x00c2
	.dw #0x00c0
	.dw #0x00be
	.dw #0x00bd
	.dw #0x00bb
	.dw #0x00b9
	.dw #0x00b8
	.dw #0x00b6
	.dw #0x00b5
	.dw #0x00b2
	.dw #0x00b1
	.dw #0x00af
	.dw #0x00ad
	.dw #0x00ab
	.dw #0x00a9
	.dw #0x00a7
	.dw #0x00a5
	.dw #0x00a3
	.dw #0x00a1
	.dw #0x009f
	.dw #0x009d
	.dw #0x009b
	.dw #0x0099
	.dw #0x0097
	.dw #0x0095
	.dw #0x0093
	.dw #0x0090
	.dw #0x008e
	.dw #0x008c
	.dw #0x008a
	.dw #0x0087
	.dw #0x0085
	.dw #0x0083
	.dw #0x0080
	.dw #0x007e
	.dw #0x007c
	.dw #0x0079
	.dw #0x0077
	.dw #0x0074
	.dw #0x0072
	.dw #0x006f
	.dw #0x006d
	.dw #0x006a
	.dw #0x0068
	.dw #0x0065
	.dw #0x0062
	.dw #0x005f
	.dw #0x005d
	.dw #0x005a
	.dw #0x0057
	.dw #0x0054
	.dw #0x0051
	.dw #0x004e
	.dw #0x004c
	.dw #0x0049
	.dw #0x0046
	.dw #0x0043
	.dw #0x0040
	.dw #0x003d
	.dw #0x003a
	.dw #0x0037
	.dw #0x0034
	.dw #0x0031
	.dw #0x002e
	.dw #0x002b
	.dw #0x0028
	.dw #0x0025
	.dw #0x0022
	.dw #0x001f
	.dw #0x001c
	.dw #0x0019
	.dw #0x0016
	.dw #0x0013
	.dw #0x0010
	.dw #0x000c
	.dw #0x0009
	.dw #0x0006
	.dw #0x0003
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0003
	.dw #0x0006
	.dw #0x0009
	.dw #0x000c
	.dw #0x0010
	.dw #0x0013
	.dw #0x0016
	.dw #0x0019
	.dw #0x001c
	.dw #0x001f
	.dw #0x0022
	.dw #0x0025
	.dw #0x0028
	.dw #0x002b
	.dw #0x002e
	.dw #0x0031
	.dw #0x0034
	.dw #0x0037
	.dw #0x003a
	.dw #0x003d
	.dw #0x0040
	.dw #0x0043
	.dw #0x0046
	.dw #0x0049
	.dw #0x004c
	.dw #0x004e
	.dw #0x0051
	.dw #0x0054
	.dw #0x0057
	.dw #0x005a
	.dw #0x005d
	.dw #0x005f
	.dw #0x0062
	.dw #0x0065
	.dw #0x0068
	.dw #0x006a
	.dw #0x006d
	.dw #0x006f
	.dw #0x0072
	.dw #0x0074
	.dw #0x0077
	.dw #0x0079
	.dw #0x007c
	.dw #0x007e
	.dw #0x0080
	.dw #0x0083
	.dw #0x0085
	.dw #0x0087
	.dw #0x008a
	.dw #0x008c
	.dw #0x008e
	.dw #0x0090
	.dw #0x0093
	.dw #0x0095
	.dw #0x0097
	.dw #0x0099
	.dw #0x009b
	.dw #0x009d
	.dw #0x009f
	.dw #0x00a1
	.dw #0x00a3
	.dw #0x00a5
	.dw #0x00a7
	.dw #0x00a9
	.dw #0x00ab
	.dw #0x00ad
	.dw #0x00af
	.dw #0x00b1
	.dw #0x00b2
	.dw #0x00b4
	.dw #0x00b6
	.dw #0x00b8
	.dw #0x00b9
	.dw #0x00bb
	.dw #0x00bd
	.dw #0x00be
	.dw #0x00c0
	.dw #0x00c2
	.dw #0x00c3
	.dw #0x00c5
	.dw #0x00c6
	.dw #0x00c8
	.dw #0x00c9
	.dw #0x00cb
	.dw #0x00cc
	.dw #0x00ce
	.dw #0x00cf
	.dw #0x00d0
	.dw #0x00d2
	.dw #0x00d3
	.dw #0x00d4
	.dw #0x00d6
	.dw #0x00d7
	.dw #0x00d8
	.dw #0x00da
;src/math-stuff.c:147: static void rotate_xz_out(const Vec3 *v, uint8_t a, Vec3 *out) {
;	---------------------------------
; Function rotate_xz_out
; ---------------------------------
_rotate_xz_out:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	iy, #-24
	add	iy, sp
	ld	sp, iy
	ld	-2 (ix), l
	ld	-1 (ix), h
;src/math-stuff.c:149: lut_rot(a, &c, &s);
	ld	hl, #6
	add	hl, sp
	push	hl
	ld	hl, #6
	add	hl, sp
	ex	de, hl
	ld	a, 4 (ix)
	call	_lut_rot
;src/math-stuff.c:151: q32_t tx = (q32_t)fmul(v->x, c) - (q32_t)fmul(v->z, s);
	ld	a, -20 (ix)
	ld	-4 (ix), a
	ld	a, -19 (ix)
	ld	-3 (ix), a
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	e, c
	ld	d, b
	ld	a, d
	rlca
	sbc	hl, hl
	ld	a, -4 (ix)
	ld	-16 (ix), a
	ld	a, -3 (ix)
	ld	-15 (ix), a
	rlca
	sbc	a, a
	ld	-14 (ix), a
	ld	-13 (ix), a
	push	bc
	push	hl
	ld	l, -14 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -13 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ex	(sp), hl
	push	hl
	ld	l, -16 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -15 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ex	(sp), hl
	call	__mullong
	pop	af
	pop	af
	pop	bc
	ld	e, d
	ld	d, l
	ld	-12 (ix), e
	ld	-11 (ix), d
	ld	e, -18 (ix)
	ld	d, -17 (ix)
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	-10 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-9 (ix), a
	ld	l, -10 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -9 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	-24 (ix), l
	ld	a, h
	ld	-23 (ix), a
	rlca
	sbc	a, a
	ld	-22 (ix), a
	ld	-21 (ix), a
	ld	-8 (ix), e
	ld	a, d
	ld	-7 (ix), a
	rlca
	sbc	a, a
	ld	-6 (ix), a
	ld	-5 (ix), a
	push	bc
	ld	l, -6 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	l, -8 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -7 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	e, -24 (ix)
	ld	d, -23 (ix)
	ld	l, -22 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -21 (ix)
;	spillPairReg hl
;	spillPairReg hl
	call	__mullong
	pop	af
	pop	af
	pop	bc
	ld	e, d
	ld	d, l
	ld	a, -12 (ix)
	sub	a, e
	ld	-4 (ix), a
	ld	a, -11 (ix)
	sbc	a, d
	ld	-3 (ix), a
;src/math-stuff.c:152: q32_t tz = (q32_t)fmul(v->x, s) + (q32_t)fmul(v->z, c);
	ld	a, b
	rlca
	sbc	hl, hl
	ld	e, -6 (ix)
	ld	d, -5 (ix)
	push	de
	ld	e, -8 (ix)
	ld	d, -7 (ix)
	push	de
	ld	e, c
	ld	d, b
	call	__mullong
	pop	af
	pop	af
	ld	c, d
	ld	b, l
	ld	e, -10 (ix)
	ld	a, -9 (ix)
	ld	d, a
	rlca
	sbc	hl, hl
	push	bc
	push	hl
	ld	l, -14 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -13 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ex	(sp), hl
	push	hl
	ld	l, -16 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -15 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ex	(sp), hl
	call	__mullong
	pop	af
	pop	af
	pop	bc
	ld	h, l
;	spillPairReg hl
;	spillPairReg hl
	ld	l, d
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	-6 (ix), l
	ld	-5 (ix), h
;src/math-stuff.c:153: out->x = (q8_8_t)tx;
	ld	c, 5 (ix)
	ld	b, 6 (ix)
	ld	l, c
	ld	h, b
	ld	a, -4 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -3 (ix)
	ld	(hl), a
;src/math-stuff.c:154: out->y = v->y;
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	-4 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-3 (ix), a
	ld	a, -4 (ix)
	ld	(de), a
	inc	de
	ld	a, -3 (ix)
	ld	(de), a
;src/math-stuff.c:155: out->z = (q8_8_t)tz;
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, -6 (ix)
	ld	(bc), a
	inc	bc
	ld	a, -5 (ix)
	ld	(bc), a
;src/math-stuff.c:156: }
	ld	sp, ix
	pop	ix
	pop	hl
	pop	af
	inc	sp
	jp	(hl)
;src/math-stuff.c:159: static void translate_z_out(const Vec3 *v, q8_8_t addz, Vec3 *out) {
;	---------------------------------
; Function translate_z_out
; ---------------------------------
_translate_z_out:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;src/math-stuff.c:160: *out = *v;
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	inc	sp
	inc	sp
	push	bc
	push	de
	push	bc
	ld	e, -2 (ix)
	ld	d, -1 (ix)
	ld	bc, #0x0006
	ldir
	pop	bc
	pop	de
;src/math-stuff.c:161: out->z = (q8_8_t)((q32_t)out->z + (q32_t)addz);
	ld	hl, #0x0004
	add	hl, bc
	ld	a, (hl)
	inc	hl
	ld	b, (hl)
	dec	hl
	add	a, e
	ld	c, a
	ld	a, b
	adc	a, d
	ld	(hl), c
	inc	hl
	ld	(hl), a
;src/math-stuff.c:162: }
	ld	sp, ix
	pop	ix
	pop	hl
	pop	af
	jp	(hl)
;src/math-stuff.c:165: static void project_out(const Vec3 *v, Vec3 *out) {
;	---------------------------------
; Function project_out
; ---------------------------------
_project_out:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	iy, #-16
	add	iy, sp
	ld	sp, iy
	ld	-2 (ix), l
	ld	-1 (ix), h
	ld	-4 (ix), e
	ld	-3 (ix), d
;src/math-stuff.c:167: q8_8_t z = v->z;
	ld	a, -2 (ix)
	ld	-6 (ix), a
	ld	a, -1 (ix)
	ld	-5 (ix), a
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	de, #0x0004
	add	hl, de
	ld	a, (hl)
	ld	-16 (ix), a
	inc	hl
	ld	a, (hl)
;src/math-stuff.c:168: if (z < Z_MIN) z = Z_MIN;
	ld	-15 (ix), a
	xor	a, #0x80
	sub	a, #0x82
	jr	NC, 00102$
	ld	hl, #0x0200
	ex	(sp), hl
00102$:
;src/math-stuff.c:170: out->x = fdiv(v->x, z); /* (x_fixed << SHIFT)/z_fixed -> Q8.8 */
	ld	a, -4 (ix)
	ld	-14 (ix), a
	ld	a, -3 (ix)
	ld	-13 (ix), a
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	a, (hl)
	ld	-6 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-5 (ix), a
;src/math-stuff.c:87: return (q8_8_t)(((q32_t)a << FP_SHIFT) / (q32_t)b);
	ld	a, -16 (ix)
	ld	-12 (ix), a
	ld	a, -15 (ix)
	ld	-11 (ix), a
	rlca
	sbc	a, a
	ld	-10 (ix), a
	ld	-9 (ix), a
;src/math-stuff.c:86: if (b == 0) return (a >= 0) ? INT16_MAX : INT16_MIN;
	ld	a, -15 (ix)
	or	a, -16 (ix)
	jr	NZ, 00104$
	ld	b, -5 (ix)
	bit	7, b
	jr	NZ, 00111$
	ld	-6 (ix), #0xff
	ld	-5 (ix), #0x7f
	jr	00105$
00111$:
	ld	-6 (ix), #0x00
	ld	-5 (ix), #0x80
	jr	00105$
00104$:
;src/math-stuff.c:87: return (q8_8_t)(((q32_t)a << FP_SHIFT) / (q32_t)b);
	ld	e, -6 (ix)
	ld	a, -5 (ix)
	ld	d, a
	rlca
	sbc	a, a
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	l, d
;	spillPairReg hl
;	spillPairReg hl
	ld	d, e
	ld	e, #0x00
	ld	c, -10 (ix)
	ld	b, -9 (ix)
	push	bc
	ld	c, -12 (ix)
	ld	b, -11 (ix)
	push	bc
	call	__divslong
	pop	af
	pop	af
	ld	-8 (ix), e
	ld	-7 (ix), d
	ld	-6 (ix), l
	ld	-5 (ix), h
	ld	a, -8 (ix)
	ld	-6 (ix), a
	ld	a, -7 (ix)
	ld	-5 (ix), a
;src/math-stuff.c:170: out->x = fdiv(v->x, z); /* (x_fixed << SHIFT)/z_fixed -> Q8.8 */
00105$:
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	a, -6 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -5 (ix)
	ld	(hl), a
;src/math-stuff.c:171: out->y = fdiv(v->y, z); //This is the Algorithm im here for!!!!!!
	ld	a, -4 (ix)
	add	a, #0x02
	ld	-8 (ix), a
	ld	a, -3 (ix)
	adc	a, #0x00
	ld	-7 (ix), a
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	-6 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-5 (ix), a
;src/math-stuff.c:86: if (b == 0) return (a >= 0) ? INT16_MAX : INT16_MIN;
	ld	a, -15 (ix)
	or	a, -16 (ix)
	jr	NZ, 00107$
	ld	b, -5 (ix)
	bit	7, b
	jr	NZ, 00113$
	ld	-6 (ix), #0xff
	ld	-5 (ix), #0x7f
	jr	00114$
00113$:
	ld	-6 (ix), #0x00
	ld	-5 (ix), #0x80
00114$:
	ld	e, -6 (ix)
	ld	d, -5 (ix)
	jr	00108$
00107$:
;src/math-stuff.c:87: return (q8_8_t)(((q32_t)a << FP_SHIFT) / (q32_t)b);
	ld	c, -6 (ix)
	ld	a, -5 (ix)
	ld	b, a
	rlca
	sbc	hl, hl
	ld	d, c
	ld	h, l
;	spillPairReg hl
;	spillPairReg hl
	ld	l, b
;	spillPairReg hl
;	spillPairReg hl
	ld	e, #0x00
	ld	c, -10 (ix)
	ld	b, -9 (ix)
	push	bc
	ld	c, -12 (ix)
	ld	b, -11 (ix)
	push	bc
	call	__divslong
	pop	af
	pop	af
;src/math-stuff.c:171: out->y = fdiv(v->y, z); //This is the Algorithm im here for!!!!!!
00108$:
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	(hl), e
	inc	hl
	ld	(hl), d
;src/math-stuff.c:172: out->z = z;
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	de, #0x0004
	add	hl, de
	ld	a, -16 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -15 (ix)
	ld	(hl), a
;src/math-stuff.c:173: }
	ld	sp, ix
	pop	ix
	ret
;src/math-stuff.c:175: static void screen_point_out(const Vec3 *p, Point2i *out) {
;	---------------------------------
; Function screen_point_out
; ---------------------------------
_screen_point_out:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	iy, #-14
	add	iy, sp
	ld	sp, iy
	ld	c, l
	ld	b, h
	ld	-2 (ix), e
	ld	-1 (ix), d
;src/math-stuff.c:177: q32_t px = (q32_t)p->x + (q32_t)FP_ONE; // shift -1..+1 -> 0..2 in Q8.8
	ld	l, c
	ld	h, b
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	a, d
	rlca
	sbc	hl, hl
	ld	a, d
	add	a, #0x01
	ld	d, a
	jr	NC, 00121$
	inc	hl
00121$:
;src/math-stuff.c:178: int32_t sx = (int32_t)((px * (q32_t)SCREEN_WIDTH) / (2 * (q32_t)FP_ONE));
	push	bc
	push	hl
	push	de
	ld	de, #0x00ff
	ld	hl, #0x0000
	call	__mullong
	pop	af
	pop	af
	ld	-6 (ix), e
	ld	-5 (ix), d
	ld	-4 (ix), l
	ld	-3 (ix), h
	pop	bc
	ld	e, -6 (ix)
	ld	d, -5 (ix)
	ld	l, -4 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -3 (ix)
;	spillPairReg hl
;	spillPairReg hl
	bit	7, -3 (ix)
	jr	Z, 00103$
	ld	a, -6 (ix)
	add	a, #0xff
	ld	e, a
	ld	a, -5 (ix)
	adc	a, #0x01
	ld	d, a
	ld	a, -4 (ix)
	adc	a, #0x00
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, -3 (ix)
	adc	a, #0x00
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
00103$:
	ld	a, #0x09
00122$:
	sra	h
	rr	l
	rr	d
	rr	e
	dec	a
	jr	NZ, 00122$
	inc	sp
	inc	sp
	push	de
	ld	-12 (ix), l
	ld	-11 (ix), h
;src/math-stuff.c:181: q32_t py = (q32_t)p->y;
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	a, b
	rlca
	sbc	hl, hl
;src/math-stuff.c:183: int32_t sy = (int32_t)((( ( (q32_t)FP_ONE - (py + (q32_t)FP_ONE) / 2 ) * (q32_t)SCREEN_HEIGHT) ) / (q32_t)FP_ONE);
	ld	-10 (ix), c
	ld	a, b
	add	a, #0x01
	ld	-9 (ix), a
	ld	a, l
	adc	a, #0x00
	ld	-8 (ix), a
	ld	a, h
	adc	a, #0x00
	ld	-7 (ix), a
	ld	a, -10 (ix)
	ld	-6 (ix), a
	ld	a, -9 (ix)
	ld	-5 (ix), a
	ld	a, -8 (ix)
	ld	-4 (ix), a
	ld	a, -7 (ix)
	ld	-3 (ix), a
	bit	7, -7 (ix)
	jr	Z, 00104$
	ld	a, c
	add	a, #0x01
	ld	-6 (ix), a
	ld	a, b
	adc	a, #0x01
	ld	-5 (ix), a
	ld	a, l
	adc	a, #0x00
	ld	-4 (ix), a
	ld	a, h
	adc	a, #0x00
	ld	-3 (ix), a
00104$:
	ld	c, -6 (ix)
	ld	b, -5 (ix)
	ld	e, -4 (ix)
	ld	d, -3 (ix)
	sra	d
	rr	e
	rr	b
	rr	c
	xor	a, a
	sub	a, c
	ld	c, a
	ld	a, #0x01
	sbc	a, b
	ld	b, a
	ld	hl, #0x0000
	sbc	hl, de
	push	hl
	push	bc
	ld	de, #0x00ef
	ld	hl, #0x0000
	call	__mullong
	pop	af
	pop	af
	ld	-6 (ix), e
	ld	-5 (ix), d
	ld	-4 (ix), l
	ld	-3 (ix), h
	bit	7, h
	jr	Z, 00105$
	ld	a, e
	add	a, #0xff
	ld	-6 (ix), a
	ld	a, d
	adc	a, #0x00
	ld	-5 (ix), a
	ld	a, l
	adc	a, #0x00
	ld	-4 (ix), a
	ld	a, h
	adc	a, #0x00
	ld	-3 (ix), a
00105$:
	ld	c, -6 (ix)
	ld	b, -5 (ix)
	ld	e, -4 (ix)
	ld	d, -3 (ix)
	ld	a, #0x08
00126$:
	sra	d
	rr	e
	rr	b
	rr	c
	dec	a
	jr	NZ, 00126$
;src/math-stuff.c:185: out->x = (int16_t)sx;
	ld	a, -14 (ix)
	ld	-4 (ix), a
	ld	a, -13 (ix)
	ld	-3 (ix), a
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	a, -4 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -3 (ix)
	ld	(hl), a
;src/math-stuff.c:186: out->y = (int16_t)sy;
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	(hl), c
	inc	hl
	ld	(hl), b
;src/math-stuff.c:187: }
	ld	sp, ix
	pop	ix
	ret
;src/math-stuff.c:189: static inline void clamp_proj(Vec3 *p) {
;	---------------------------------
; Function clamp_proj
; ---------------------------------
_clamp_proj:
;src/math-stuff.c:190: if (p->x < -FP_ONE) p->x = -FP_ONE;
	inc	hl
	ld	b, (hl)
	dec	hl
	ld	a, b
	xor	a, #0x80
	sub	a, #0x7f
	jr	NC, 00102$
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0xff
	dec	hl
00102$:
;src/math-stuff.c:191: if (p->x >  FP_ONE) p->x =  FP_ONE;
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	dec	hl
	xor	a, a
	cp	a, c
	ld	a, #0x01
	sbc	a, b
	jp	PO, 00131$
	xor	a, #0x80
00131$:
	jp	P, 00104$
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x01
	dec	hl
00104$:
;src/math-stuff.c:192: if (p->y < -FP_ONE) p->y = -FP_ONE;
	inc	hl
	inc	hl
	inc	hl
	ld	b, (hl)
	dec	hl
	ld	a, b
	xor	a, #0x80
	sub	a, #0x7f
	jr	NC, 00106$
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0xff
	dec	hl
00106$:
;src/math-stuff.c:193: if (p->y >  FP_ONE) p->y =  FP_ONE;
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	dec	hl
	xor	a, a
	cp	a, c
	ld	a, #0x01
	sbc	a, b
	jp	PO, 00132$
	xor	a, #0x80
00132$:
	ret	P
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x01
;src/math-stuff.c:194: }
	ret
;src/math-stuff.c:197: void frame(void) {
;	---------------------------------
; Function frame
; ---------------------------------
_frame::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-56
	add	hl, sp
	ld	sp, hl
;src/math-stuff.c:199: angle = (uint8_t)(angle + ANGLE_STEP);
	ld	a, (_angle+0)
	ld	c, a
	ld	a, (_ANGLE_STEP+0)
	add	a, c
	ld	(_angle+0), a
	ld	hl, #_angle + 1
	ld	(hl), #0x00
;src/math-stuff.c:201: clear_screen(); //Slow as hell, but what are you gonna do about it?
	call	_clear_screen
;src/math-stuff.c:204: for (uint16_t fi = 0; fi < fs_count; ++fi) {
	xor	a, a
	ld	-3 (ix), a
	ld	-2 (ix), a
00131$:
	ld	hl, (_fs_count)
	ld	-5 (ix), l
	ld	-4 (ix), h
	ld	a, -3 (ix)
	sub	a, -5 (ix)
	ld	a, -2 (ix)
	sbc	a, -4 (ix)
	jp	NC, 00132$
;src/math-stuff.c:205: const uint8_t *face = fs[fi];
	ld	a, -3 (ix)
	ld	-7 (ix), a
	ld	a, -2 (ix)
	ld	-6 (ix), a
	sla	-7 (ix)
	rl	-6 (ix)
	ld	a, -7 (ix)
	add	a, #<(_fs)
	ld	-5 (ix), a
	ld	a, -6 (ix)
	adc	a, #>(_fs)
	ld	-4 (ix), a
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	ld	-10 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-9 (ix), a
;src/math-stuff.c:206: uint8_t len = fs_len[fi];
	ld	a, #<(_fs_len)
	add	a, -3 (ix)
	ld	c, a
	ld	a, #>(_fs_len)
	adc	a, -2 (ix)
	ld	b, a
	ld	a, (bc)
;src/math-stuff.c:207: if (len < 2) continue;
	ld	-8 (ix), a
	sub	a, #0x02
	jp	C, 00108$
;src/math-stuff.c:209: for (uint8_t i = 0; i < len; ++i) {
	ld	-1 (ix), #0x00
00129$:
	ld	a, -1 (ix)
	sub	a, -8 (ix)
	jp	NC, 00108$
;src/math-stuff.c:210: uint8_t idx_a = face[i];
	ld	a, -10 (ix)
	add	a, -1 (ix)
	ld	-5 (ix), a
	ld	a, -9 (ix)
	adc	a, #0x00
	ld	-4 (ix), a
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	ld	-7 (ix), a
;src/math-stuff.c:211: uint8_t idx_b = face[(i + 1) % len];
	ld	a, -1 (ix)
	ld	-5 (ix), a
	ld	-4 (ix), #0x00
	ld	a, -5 (ix)
	add	a, #0x01
	ld	-56 (ix), a
	ld	a, -4 (ix)
	adc	a, #0x00
	ld	-55 (ix), a
	ld	a, -8 (ix)
	ld	-5 (ix), a
	ld	-4 (ix), #0x00
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	call	__modsint
	inc	sp
	inc	sp
	push	de
	ld	a, -56 (ix)
	add	a, -10 (ix)
	ld	-5 (ix), a
	ld	a, -55 (ix)
	adc	a, -9 (ix)
	ld	-4 (ix), a
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	ld	-6 (ix), a
;src/math-stuff.c:212: if (idx_a >= vs_count || idx_b >= vs_count) continue;
	ld	hl, (_vs_count)
	ld	-5 (ix), l
	ld	-4 (ix), h
	ld	a, -7 (ix)
	ld	b, #0x00
	sub	a, -5 (ix)
	ld	a, b
	sbc	a, -4 (ix)
	jp	NC, 00106$
	ld	a, -6 (ix)
	ld	b, #0x00
	sub	a, -5 (ix)
	ld	a, b
	sbc	a, -4 (ix)
	jp	NC, 00106$
;src/math-stuff.c:217: va = vs[idx_a];
	ld	hl, #2
	add	hl, sp
	ex	de, hl
	ld	c, -7 (ix)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	bc, #_vs
	add	hl, bc
	ld	bc, #0x0006
	ldir
;src/math-stuff.c:218: vb = vs[idx_b];
	ld	hl, #8
	add	hl, sp
	ex	de, hl
	ld	c, -6 (ix)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	bc, #_vs
	add	hl, bc
	ld	bc, #0x0006
	ldir
;src/math-stuff.c:224: rotate_xz_out(&va, angle, &ra);
	ld	a, (_angle+0)
	ld	hl, #14
	add	hl, sp
	push	hl
	push	af
	inc	sp
	ld	hl, #5
	add	hl, sp
	call	_rotate_xz_out
;src/math-stuff.c:225: translate_z_out(&ra, dz, &ra);
	ld	hl, #14
	add	hl, sp
	push	hl
	ld	de, (_dz)
	ld	hl, #16
	add	hl, sp
	call	_translate_z_out
;src/math-stuff.c:226: project_out(&ra, &pa);
	ld	hl, #20
	add	hl, sp
	ex	de, hl
	ld	hl, #14
	add	hl, sp
	call	_project_out
;src/math-stuff.c:227: clamp_proj(&pa);
	ld	hl, #20
	add	hl, sp
	ld	e, l
	ld	d, h
;src/math-stuff.c:190: if (p->x < -FP_ONE) p->x = -FP_ONE;
	inc	hl
	ld	b, (hl)
	dec	hl
	ld	a, b
	xor	a, #0x80
	sub	a, #0x7f
	jr	NC, 00111$
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0xff
00111$:
;src/math-stuff.c:191: if (p->x >  FP_ONE) p->x =  FP_ONE;
	ld	l, e
	ld	h, d
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	xor	a, a
	cp	a, c
	ld	a, #0x01
	sbc	a, b
	jp	PO, 00212$
	xor	a, #0x80
00212$:
	jp	P, 00113$
	ld	l, e
	ld	h, d
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x01
00113$:
;src/math-stuff.c:192: if (p->y < -FP_ONE) p->y = -FP_ONE;
	ex	de, hl
	inc	hl
	inc	hl
	inc	hl
	ld	b, (hl)
	dec	hl
	ld	a, b
	xor	a, #0x80
	sub	a, #0x7f
	jr	NC, 00115$
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0xff
	dec	hl
00115$:
;src/math-stuff.c:193: if (p->y >  FP_ONE) p->y =  FP_ONE;
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	dec	hl
	xor	a, a
	cp	a, c
	ld	a, #0x01
	sbc	a, b
	jp	PO, 00213$
	xor	a, #0x80
00213$:
	jp	P, 00118$
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x01
;src/math-stuff.c:227: clamp_proj(&pa);
00118$:
;src/math-stuff.c:228: screen_point_out(&pa, &sa);
	ld	hl, #38
	add	hl, sp
	ex	de, hl
	ld	hl, #20
	add	hl, sp
	call	_screen_point_out
;src/math-stuff.c:230: rotate_xz_out(&vb, angle, &rb);
	ld	a, (_angle+0)
	ld	hl, #26
	add	hl, sp
	push	hl
	push	af
	inc	sp
	ld	hl, #11
	add	hl, sp
	call	_rotate_xz_out
;src/math-stuff.c:231: translate_z_out(&rb, dz, &rb);
	ld	hl, #26
	add	hl, sp
	push	hl
	ld	de, (_dz)
	ld	hl, #28
	add	hl, sp
	call	_translate_z_out
;src/math-stuff.c:232: project_out(&rb, &pb);
	ld	hl, #32
	add	hl, sp
	ex	de, hl
	ld	hl, #26
	add	hl, sp
	call	_project_out
;src/math-stuff.c:233: clamp_proj(&pb);
	ld	hl, #32
	add	hl, sp
	ld	e, l
	ld	d, h
;src/math-stuff.c:190: if (p->x < -FP_ONE) p->x = -FP_ONE;
	inc	hl
	ld	b, (hl)
	dec	hl
	ld	a, b
	xor	a, #0x80
	sub	a, #0x7f
	jr	NC, 00120$
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0xff
00120$:
;src/math-stuff.c:191: if (p->x >  FP_ONE) p->x =  FP_ONE;
	ld	l, e
	ld	h, d
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	xor	a, a
	cp	a, c
	ld	a, #0x01
	sbc	a, b
	jp	PO, 00214$
	xor	a, #0x80
00214$:
	jp	P, 00122$
	ld	l, e
	ld	h, d
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x01
00122$:
;src/math-stuff.c:192: if (p->y < -FP_ONE) p->y = -FP_ONE;
	ex	de, hl
	inc	hl
	inc	hl
	inc	hl
	ld	b, (hl)
	dec	hl
	ld	a, b
	xor	a, #0x80
	sub	a, #0x7f
	jr	NC, 00124$
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0xff
	dec	hl
00124$:
;src/math-stuff.c:193: if (p->y >  FP_ONE) p->y =  FP_ONE;
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	dec	hl
	xor	a, a
	cp	a, c
	ld	a, #0x01
	sbc	a, b
	jp	PO, 00215$
	xor	a, #0x80
00215$:
	jp	P, 00127$
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x01
;src/math-stuff.c:233: clamp_proj(&pb);
00127$:
;src/math-stuff.c:234: screen_point_out(&pb, &sb);
	ld	hl, #42
	add	hl, sp
	ex	de, hl
	ld	hl, #32
	add	hl, sp
	call	_screen_point_out
;src/math-stuff.c:236: draw_line(sa.x, sa.y, sb.x, sb.y);
	ld	c, -12 (ix)
	ld	b, -11 (ix)
	ld	a, -14 (ix)
	ld	-5 (ix), a
	ld	a, -13 (ix)
	ld	-4 (ix), a
	ld	e, -16 (ix)
	ld	d, -15 (ix)
	ld	l, -18 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -17 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	ld	c, -5 (ix)
	ld	b, -4 (ix)
	push	bc
	call	_draw_line
00106$:
;src/math-stuff.c:209: for (uint8_t i = 0; i < len; ++i) {
	inc	-1 (ix)
	jp	00129$
00108$:
;src/math-stuff.c:204: for (uint16_t fi = 0; fi < fs_count; ++fi) {
	inc	-3 (ix)
	jp	NZ,00131$
	inc	-2 (ix)
	jp	00131$
00132$:
;src/math-stuff.c:239: }
	ld	sp, ix
	pop	ix
	ret
	.area _TEXT
	.area _INITIALIZER
__xinit__dz:
	.dw #0x0300
__xinit__angle:
	.dw #0x0000
	.area _CABS (ABS)
