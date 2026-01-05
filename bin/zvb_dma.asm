;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.module zvb_dma
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _zvb_dma_virt_to_phys
	.globl _zvb_dma_start_transfer
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
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
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
;src/zvb_dma.c:5: uint32_t zvb_dma_virt_to_phys(void* ptr) __naked {
;	---------------------------------
; Function zvb_dma_virt_to_phys
; ---------------------------------
_zvb_dma_virt_to_phys::
;src/zvb_dma.c:29: );
	ld	e, l
	ld	a, h
	and	#0x3f
	ld	d, a
	ld	a, h
	in	a, (#0xF0)
	rrca
	rrca
	ld	h, a
	and	#0xc0
	or	d
	ld	d, a
	ld	a, h
	and	#0x3f
	ld	l, a
	ld	h, #0
	ret
;src/zvb_dma.c:30: }
;src/zvb_dma.c:31: uint8_t zvb_dma_start_transfer(zvb_dma_descriptor_t *desc) {
;	---------------------------------
; Function zvb_dma_start_transfer
; ---------------------------------
_zvb_dma_start_transfer::
;src/zvb_dma.c:32: uint32_t desc_phys_addr = zvb_dma_virt_to_phys(desc);
	call	_zvb_dma_virt_to_phys
;/home/smeagol/dev/Zeal/Zeal-VideoBoard-SDK//include/zvb_hardware.h:61: zvb_config_dev_idx = periph;
	ld	a, #0x04
	out	(_zvb_config_dev_idx), a
;src/zvb_dma.c:35: zvb_peri_dma_addr0 = (desc_phys_addr >> 0) & 0xFF;
	ld	a, e
	out	(_zvb_peri_dma_addr0), a
;src/zvb_dma.c:36: zvb_peri_dma_addr1 = (desc_phys_addr >> 8) & 0xFF;
	ld	a, d
	out	(_zvb_peri_dma_addr1), a
;src/zvb_dma.c:37: zvb_peri_dma_addr2 = (desc_phys_addr >> 16) & 0xFF;
	ld	a, l
	out	(_zvb_peri_dma_addr2), a
;src/zvb_dma.c:38: zvb_peri_dma_ctrl = ZVB_PERI_DMA_CTRL_START;
	ld	a, #0x80
	out	(_zvb_peri_dma_ctrl), a
;src/zvb_dma.c:40: return 0; // ERR_SUCCESS
	xor	a, a
;src/zvb_dma.c:41: }
	ret
	.area _TEXT
	.area _INITIALIZER
	.area _CABS (ABS)
