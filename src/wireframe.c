/*
 * wireframe.c - Draws and rotates a 3D pyramid
 *
 *  Compile with ""cmake""
 *
 *  Author: Samael, 2026
 *  Wireframe and rendering logic: by Alexey Kutepov (alias Tsoding).
 *
 *  License: i don't know and care
 *
 *  Tsoding's Youtube Video: https://youtu.be/qjWkNZ0SXfo
 *
 */

#include <stdint.h>
#include <stddef.h>
#include <zos_sys.h>
#include <zos_vfs.h>
#include <zos_video.h>
#include <zvb_gfx.h>
#include <zvb_dma.h>
#include <keyboard.h>
#include "math-stuff.h"

#define SCREEN_WIDTH 256
#define SCREEN_HEIGHT 240
#define PAGE_SIZE (16u * 1024u)

uint8_t current_page2;
__sfr __at(0xF2) mmu_page2;
__sfr __banked __at(0x9C) vid_mode;
uint8_t __at(0x8000) SCREEN[PAGE_SIZE];
static inline int abs(int v) { return v < 0 ? -v : v; } //How said  i don't have abs?
gfx_context vctx;

static inline void map_vram(uint8_t page) //Page is relative to tileset memory
{
    current_page2 = page;
    mmu_page2 = (VID_MEM_TILESET_ADDR >> 14) + page;
}

void screen_write(int x, int y, uint8_t color)
{
    uint8_t page = y >> 6;                 // Bitshift is cheaper than *255
    uint16_t offset = ((y & 0x3F) << 8) | x;
    map_vram(page);
    SCREEN[offset] = color;
}

void draw_line(line_t *line)
{
    int dx, dy, sx, sy, err, e2;

    dx = abs(line->sb.y - line->sa.y);
    dy = abs(line->sb.x - line->sa.x);
    sx = (line->sa.y < line->sb.y) ? 1 : -1;
    sy = (line->sa.x < line->sb.x) ? 1 : -1;
    err = dx - dy;

    while (1) {
        screen_write(line->sa.x, line->sa.y, 10); //Change color here
        if (line->sa.y == line->sb.y && line->sa.x == line->sb.x)
            break;
        e2 = err << 1;
        if (e2 > -dy) {
            err -= dy;
            line->sa.y += sx;
        }
        if (e2 < dx) {
            err += dx;
            line->sa.x += sy;
        }
    }
}

zvb_dma_descriptor_t dma_descriptor = {
    .rd_addr_lo = 0,
    .rd_addr_hi = 17,
    .wr_addr_lo = 1,
    .wr_addr_hi = 17,
    .length = 61440,
    .flags.raw = 0b00000001
};

void clear_screen(void)
{
    map_vram(0);
    SCREEN[0] = 0;
    zvb_dma_start_transfer(&dma_descriptor);
}


kb_keys_t key;
int main(void)
{
    gfx_error err = gfx_initialize(ZVB_CTRL_VID_MODE_BITMAP_256_MODE, &vctx);
    kb_mode_non_block_raw();

    while (1) {
        gfx_wait_vblank(&vctx);
        frame();
        gfx_wait_end_vblank(&vctx);

        key = getkey();
        if(key == KB_ESC) goto quit;

    } //Mainloop
quit:
    kb_mode_default();
    ioctl(DEV_STDOUT, CMD_RESET_SCREEN, NULL);
    return 0;
}
