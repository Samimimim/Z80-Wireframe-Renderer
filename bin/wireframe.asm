;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.module wireframe
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _clear_screen
	.globl _draw_line
	.globl _draw_dot
	.globl _screen_write
	.globl _zvb_dma_start_transfer
	.globl _frame
	.globl _dma_descriptor
	.globl _SCREEN
	.globl _current_page2
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_zvb_config_ver_rev	=	0x0080
_zvb_config_ver_min	=	0x0081
_zvb_config_ver_maj	=	0x0082
_zvb_config_dev_idx	=	0x008e
_zvb_config_phys_addr	=	0x008f
_zvb_ctrl_vpos_low	=	0x0090
_zvb_ctrl_vpos_high	=	0x0091
_zvb_ctrl_hpos_low	=	0x0092
_zvb_ctrl_hpos_high	=	0x0093
_zvb_ctrl_l0_scr_y_low	=	0x0094
_zvb_ctrl_l0_scr_y_high	=	0x0095
_zvb_ctrl_l0_scr_x_low	=	0x0096
_zvb_ctrl_l0_scr_x_high	=	0x0097
_zvb_ctrl_l1_scr_y_low	=	0x0098
_zvb_ctrl_l1_scr_y_high	=	0x0099
_zvb_ctrl_l1_scr_x_low	=	0x009a
_zvb_ctrl_l1_scr_x_high	=	0x009b
_zvb_ctrl_video_mode	=	0x009c
_zvb_ctrl_status	=	0x009d
_zvb_peri_text_print_char	=	0x00a0
_zvb_peri_text_curs_y	=	0x00a1
_zvb_peri_text_curs_x	=	0x00a2
_zvb_peri_text_scroll_y	=	0x00a3
_zvb_peri_text_scroll_x	=	0x00a4
_zvb_peri_text_color	=	0x00a5
_zvb_peri_text_curs_time	=	0x00a6
_zvb_peri_text_curs_char	=	0x00a7
_zvb_peri_text_curs_color	=	0x00a8
_zvb_peri_text_ctrl	=	0x00a9
_zvb_peri_spi_ctrl	=	0x00a1
_zvb_peri_spi_clk_div	=	0x00a2
_zvb_peri_spi_ram_len	=	0x00a3
_zvb_peri_spi_fifo	=	0x00a7
_zvb_peri_spi_array_0	=	0x00a8
_zvb_peri_spi_array_1	=	0x00a9
_zvb_peri_spi_array_2	=	0x00aa
_zvb_peri_spi_array_3	=	0x00ab
_zvb_peri_spi_array_4	=	0x00ac
_zvb_peri_spi_array_5	=	0x00ad
_zvb_peri_spi_array_6	=	0x00ae
_zvb_peri_spi_array_7	=	0x00af
_zvb_peri_crc_ctrl	=	0x00a0
_zvb_peri_crc_data_in	=	0x00a1
_zvb_peri_crc_byte0	=	0x00a4
_zvb_peri_crc_byte1	=	0x00a5
_zvb_peri_crc_byte2	=	0x00a6
_zvb_peri_crc_byte3	=	0x00a7
_zvb_peri_sound_freq_low	=	0x00a0
_zvb_peri_sound_freq_high	=	0x00a1
_zvb_peri_sound_wave	=	0x00a2
_zvb_peri_sound_volume	=	0x00a3
_zvb_peri_sound_sample_fifo	=	0x00a0
_zvb_peri_sound_sample_div	=	0x00a1
_zvb_peri_sound_sample_conf	=	0x00a2
_zvb_peri_sound_left_channel	=	0x00ab
_zvb_peri_sound_right_channel	=	0x00ac
_zvb_peri_sound_hold	=	0x00ad
_zvb_peri_sound_master_vol	=	0x00ae
_zvb_peri_sound_select	=	0x00af
_zvb_peri_dma_ctrl	=	0x00a0
_zvb_peri_dma_addr0	=	0x00a1
_zvb_peri_dma_addr1	=	0x00a2
_zvb_peri_dma_addr2	=	0x00a3
_zvb_peri_dma_clk_div	=	0x00a9
_mmu_page2	=	0x00f2
_vid_mode	=	0x009c
_vid_stat	=	0x009d
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_current_page2::
	.ds 1
_SCREEN	=	0x8000
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_dma_descriptor::
	.ds 12
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
;/home/smeagol/dev/Zeal/Zeal-VideoBoard-SDK//include/zvb_hardware.h:59: static inline void zvb_map_peripheral(uint8_t periph)
;	---------------------------------
; Function zvb_map_peripheral
; ---------------------------------
_zvb_map_peripheral:
	out	(_zvb_config_dev_idx), a
;/home/smeagol/dev/Zeal/Zeal-VideoBoard-SDK//include/zvb_hardware.h:61: zvb_config_dev_idx = periph;
;/home/smeagol/dev/Zeal/Zeal-VideoBoard-SDK//include/zvb_hardware.h:62: }
	ret
;src/wireframe.c:56: static int abs(int v) { return v < 0 ? -v : v; } //How said  i don't have abs?
;	---------------------------------
; Function abs
; ---------------------------------
_abs:
	bit	7, h
	jr	Z, 00103$
	xor	a, a
	sub	a, l
	ld	e, a
	sbc	a, a
	sub	a, h
	ld	d, a
	ret
00103$:
	ex	de, hl
	ret
;src/wireframe.c:59: static inline void map_vram(uint8_t page) //Page is relative to tileset memory
;	---------------------------------
; Function map_vram
; ---------------------------------
_map_vram:
	ld	c, a
;src/wireframe.c:61: current_page2 = page;
	ld	hl, #_current_page2
	ld	(hl), c
;src/wireframe.c:63: mmu_page2 = 68 + page;
	ld	a, c
	add	a, #0x44
	out	(_mmu_page2), a
;src/wireframe.c:64: }
	ret
;src/wireframe.c:66: void screen_write(uint8_t x, uint8_t y, uint8_t color)
;	---------------------------------
; Function screen_write
; ---------------------------------
_screen_write::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	c, a
;src/wireframe.c:68: uint8_t page = y >> 6;                 // Bitshift is cheaper than *255
	ld	a, l
	rlca
	rlca
	and	a, #0x03
	ld	e, a
;src/wireframe.c:69: uint16_t offset = ((y & 0x3F) << 8) | x;
;	spillPairReg hl
;	spillPairReg hl
	ld	a, l
	and	a, #0x3f
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	ld	l, #0x00
	ld	b, l
	ld	a, c
	or	a, l
	ld	c, a
	ld	a, b
	or	a, h
	ld	b, a
;src/wireframe.c:71: if (page != current_page2)
	ld	a, (_current_page2+0)
	sub	a, e
	jr	Z, 00102$
;src/wireframe.c:61: current_page2 = page;
	ld	iy, #_current_page2
	ld	0 (iy), e
;src/wireframe.c:63: mmu_page2 = 68 + page;
	ld	a, e
	add	a, #0x44
	out	(_mmu_page2), a
;src/wireframe.c:72: map_vram(page);
00102$:
;src/wireframe.c:74: ((uint8_t*)0x8000)[offset] = color;
	ld	hl, #0x8000
	add	hl, bc
	ld	a, 4 (ix)
	ld	(hl), a
;src/wireframe.c:75: }
	pop	ix
	pop	hl
	inc	sp
	jp	(hl)
;src/wireframe.c:77: void draw_dot(int x, int y, uint8_t color, int size)
;	---------------------------------
; Function draw_dot
; ---------------------------------
_draw_dot::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	ex	(sp), hl
;src/wireframe.c:81: for (dy = 0; dy < size; dy++) {
	ld	bc, #0x0000
00107$:
	ld	a, c
	sub	a, 5 (ix)
	ld	a, b
	sbc	a, 6 (ix)
	jp	PO, 00133$
	xor	a, #0x80
00133$:
	jp	P, 00109$
;src/wireframe.c:82: for (dx = 0; dx < size; dx++) {
	xor	a, a
	ld	-2 (ix), a
	ld	-1 (ix), a
00104$:
	ld	a, -2 (ix)
	sub	a, 5 (ix)
	ld	a, -1 (ix)
	sbc	a, 6 (ix)
	jp	PO, 00134$
	xor	a, #0x80
00134$:
	jp	P, 00108$
;src/wireframe.c:83: screen_write(x + dx, y + dy, color);
	ld	a, e
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	add	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, -4 (ix)
	ld	h, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	add	a, h
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	push	de
	ld	a, 4 (ix)
	push	af
	inc	sp
	ld	a, h
	call	_screen_write
	pop	de
	pop	bc
;src/wireframe.c:82: for (dx = 0; dx < size; dx++) {
	inc	-2 (ix)
	jr	NZ, 00104$
	inc	-1 (ix)
	jr	00104$
00108$:
;src/wireframe.c:81: for (dy = 0; dy < size; dy++) {
	inc	bc
	jr	00107$
00109$:
;src/wireframe.c:86: }
	ld	sp, ix
	pop	ix
	pop	hl
	pop	af
	inc	sp
	jp	(hl)
;src/wireframe.c:88: void draw_line(int16_t x1, int16_t y1, int16_t x2, int16_t y2)
;	---------------------------------
; Function draw_line
; ---------------------------------
_draw_line::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	iy, #-20
	add	iy, sp
	ld	sp, iy
	ld	-4 (ix), l
	ld	-3 (ix), h
	ld	-6 (ix), e
	ld	-5 (ix), d
;src/wireframe.c:93: dx = abs(y2 - y1);
	ld	a, 6 (ix)
	sub	a, -6 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, 7 (ix)
	sbc	a, -5 (ix)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	call	_abs
	inc	sp
	inc	sp
	push	de
;src/wireframe.c:94: dy = abs(x2 - x1);
	ld	a, 4 (ix)
	sub	a, -4 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, 5 (ix)
	sbc	a, -3 (ix)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	call	_abs
	ld	-18 (ix), e
	ld	-17 (ix), d
;src/wireframe.c:95: sx = (y1 < y2) ? 1 : -1;
	ld	a, -6 (ix)
	sub	a, 6 (ix)
	ld	a, -5 (ix)
	sbc	a, 7 (ix)
	jp	PO, 00147$
	xor	a, #0x80
00147$:
	jp	P, 00113$
	ld	-2 (ix), #0x01
	ld	-1 (ix), #0
	jr	00114$
00113$:
	ld	-2 (ix), #0xff
	ld	-1 (ix), #0xff
00114$:
	ld	a, -2 (ix)
	ld	-16 (ix), a
	ld	a, -1 (ix)
	ld	-15 (ix), a
;src/wireframe.c:96: sy = (x1 < x2) ? 1 : -1;
	ld	a, -4 (ix)
	sub	a, 4 (ix)
	ld	a, -3 (ix)
	sbc	a, 5 (ix)
	jp	PO, 00148$
	xor	a, #0x80
00148$:
	jp	P, 00115$
	ld	de, #0x0001
	jr	00116$
00115$:
	ld	de, #0xffff
00116$:
	ld	-14 (ix), e
	ld	-13 (ix), d
;src/wireframe.c:97: err = dx - dy;
	ld	a, -20 (ix)
	sub	a, -18 (ix)
	ld	-2 (ix), a
	ld	a, -19 (ix)
	sbc	a, -17 (ix)
	ld	-1 (ix), a
;src/wireframe.c:99: while (1) {
	xor	a, a
	sub	a, -18 (ix)
	ld	-12 (ix), a
	sbc	a, a
	sub	a, -17 (ix)
	ld	-11 (ix), a
00109$:
;src/wireframe.c:100: draw_dot(x1, y1, 5, size);
	ld	a, -6 (ix)
	ld	-10 (ix), a
	ld	a, -5 (ix)
	ld	-9 (ix), a
	ld	a, -4 (ix)
	ld	-8 (ix), a
	ld	a, -3 (ix)
	ld	-7 (ix), a
	ld	hl, #0x0001
	push	hl
	ld	a, #0x05
	push	af
	inc	sp
	ld	e, -10 (ix)
	ld	d, -9 (ix)
	ld	l, -8 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -7 (ix)
;	spillPairReg hl
;	spillPairReg hl
	call	_draw_dot
;src/wireframe.c:102: if (y1 == y2 && x1 == x2)
	ld	a, -6 (ix)
	sub	a, 6 (ix)
	jr	NZ, 00102$
	ld	a, -5 (ix)
	sub	a, 7 (ix)
	jr	NZ, 00102$
	ld	a, 4 (ix)
	sub	a, -4 (ix)
	jr	NZ, 00151$
	ld	a, 5 (ix)
	sub	a, -3 (ix)
	jr	Z, 00111$
00151$:
;src/wireframe.c:103: break;
00102$:
;src/wireframe.c:105: e2 = err << 1;
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	add	hl, hl
;src/wireframe.c:107: if (e2 > -dy) {
	ld	a, -12 (ix)
	sub	a, l
	ld	a, -11 (ix)
	sbc	a, h
	jp	PO, 00152$
	xor	a, #0x80
00152$:
	jp	P, 00105$
;src/wireframe.c:108: err -= dy;
	ld	a, -2 (ix)
	sub	a, -18 (ix)
	ld	-2 (ix), a
	ld	a, -1 (ix)
	sbc	a, -17 (ix)
	ld	-1 (ix), a
;src/wireframe.c:109: y1 += sx;
	ld	a, -10 (ix)
	add	a, -16 (ix)
	ld	c, a
	ld	a, -9 (ix)
	adc	a, -15 (ix)
	ld	-6 (ix), c
	ld	-5 (ix), a
00105$:
;src/wireframe.c:111: if (e2 < dx) {
	ld	a, l
	sub	a, -20 (ix)
	ld	a, h
	sbc	a, -19 (ix)
	jp	PO, 00153$
	xor	a, #0x80
00153$:
	jp	P, 00109$
;src/wireframe.c:112: err += dx;
	ld	a, -2 (ix)
	add	a, -20 (ix)
	ld	-2 (ix), a
	ld	a, -1 (ix)
	adc	a, -19 (ix)
	ld	-1 (ix), a
;src/wireframe.c:113: x1 += sy;
	ld	a, -8 (ix)
	add	a, -14 (ix)
	ld	c, a
	ld	a, -7 (ix)
	adc	a, -13 (ix)
	ld	-4 (ix), c
	ld	-3 (ix), a
	jp	00109$
00111$:
;src/wireframe.c:116: }
	ld	sp, ix
	pop	ix
	pop	hl
	pop	af
	pop	af
	jp	(hl)
;src/wireframe.c:127: void clear_screen()
;	---------------------------------
; Function clear_screen
; ---------------------------------
_clear_screen::
;src/wireframe.c:61: current_page2 = page;
	ld	iy, #_current_page2
	ld	0 (iy), #0x00
;src/wireframe.c:63: mmu_page2 = 68 + page;
	ld	a, #0x44
	out	(_mmu_page2), a
;src/wireframe.c:130: SCREEN[0][0] = 0;
	ld	hl, #_SCREEN
	ld	(hl), #0x00
;src/wireframe.c:131: zvb_dma_start_transfer(&dma_descriptor);
	ld	hl, #_dma_descriptor
;src/wireframe.c:132: }
	jp	_zvb_dma_start_transfer
;src/wireframe.c:135: int main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
;src/wireframe.c:137: vid_mode = 2;
	ld	a, #0x02
	ld	bc, #_vid_mode
	out	(c),a
;src/wireframe.c:61: current_page2 = page;
	ld	hl, #_current_page2
	ld	(hl), #0x00
;src/wireframe.c:63: mmu_page2 = 68 + page;
	ld	a, #0x44
	out	(_mmu_page2), a
;src/wireframe.c:138: map_vram(0);
00103$:
;src/wireframe.c:139: for (;;) {frame();} //Mainloop
	call	_frame
;src/wireframe.c:140: return 0;
;src/wireframe.c:141: }
	jr	00103$
	.area _TEXT
	.area _INITIALIZER
__xinit__dma_descriptor:
	.dw #0x0000
	.db #0x11	; 17
	.dw #0x0001
	.db #0x11	; 17
	.dw #0xf000
	.db #0x01	; 1
	.db 0x00
	.db 0x00
	.db 0x00
	.area _CABS (ABS)
