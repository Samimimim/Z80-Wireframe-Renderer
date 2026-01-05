/*
 * wireframe.c - Draws and rotates a 3D cube
 *
 *  Compile with ""make""  
 *
 *  Author: Samael, 2026
 *  Wireframe and rendering logic: by Alexey Kutepov (alias Tsoding).
 * 
 *  License: i don't know and care
 *
 *  Tsoding's Youtube Video: https://youtu.be/qjWkNZ0SXfo
 *
 */

//TODO: Video Modus Initialisieren                               [x]
//TODO: Map_VRAM Funktion                                        [x]
//TODO: clear_screen funktion                                    [x]
//TODO: Test ob alles soweit klappt                              [x]
//TODO: Draw_Dot Funktion                                        [x]
//TODO: Draw_Line Funktion                                       [x]
//TODO: Funktionen aus                                           [x]
//https://www.youtube.com/watch?v=qjWkNZ0SXfo Impliementieren
//TODO: Debugging                                                [x]
//TODO: Frezze Screen while clearing                             [ ](Imposible)
//TODO: Clear Sreen using DRM                                    [x]
//TODO: cos/sin using lookup                                     [x]
//TODO: write screen_write/map_vram in asm                       [ ]
//BUGFIX: Cube stops spinning after fith iteration               [x]
//TODO: Pentagon as deafault modell
//FETRTIG!!!!                                                    [ ]


/*
 * +-------------------Current Problem------------------------+
 * |                                                          |
 * |      Cube spins half a turn, changes direction,          |
 * |        become an frankenstein and return to default stat.|
 * |                                                          |
 * +----------------------------------------------------------+
*/

#include <stdint.h>
#include "math-stuff.h"
#include "sdcc.h"
#include "zvb_dma.h"//Hat too include it localy, my linker is buggy

#define SCREEN_WIDTH 256
#define SCREEN_HEIGHT 240
#define display_OF 0 
#define display_ON 1<<7
uint8_t current_page2;
__sfr __at(0xF2) mmu_page2;
__sfr __banked __at(0x9C) vid_mode;
__sfr __banked __at(0x9D) vid_stat;
uint8_t __at(0x8000) SCREEN[SCREEN_HEIGHT][SCREEN_WIDTH];
static int abs(int v) { return v < 0 ? -v : v; } //How said  i don't have abs?


static inline void map_vram(uint8_t page) //Page is relative to tileset memory
{
    current_page2 = page;
    //((VID_MEM_PHYS_ADDR_START + 64 * 1024) >> 14); //This gives a Warning so i hardcode it to 68
    mmu_page2 = 68 + page;
}

void screen_write(uint8_t x, uint8_t y, uint8_t color)
{
    uint8_t page = y >> 6;                 // Bitshift is cheaper than *255
    uint16_t offset = ((y & 0x3F) << 8) | x;

    if (page != current_page2)
        map_vram(page);

    ((uint8_t*)0x8000)[offset] = color;
}

void draw_dot(int x, int y, uint8_t color, int size)
{
    int dx, dy;

    for (dy = 0; dy < size; dy++) {
        for (dx = 0; dx < size; dx++) {
            screen_write(x + dx, y + dy, color);
        }
    }
}

void draw_line(int16_t x1, int16_t y1, int16_t x2, int16_t y2)
{
    uint8_t size = 1;
    int dx, dy, sx, sy, err, e2;

    dx = abs(y2 - y1);
    dy = abs(x2 - x1);
    sx = (y1 < y2) ? 1 : -1;
    sy = (x1 < x2) ? 1 : -1;
    err = dx - dy;

    while (1) {
        draw_dot(x1, y1, 5, size);

        if (y1 == y2 && x1 == x2)
            break;

        e2 = err << 1;

        if (e2 > -dy) {
            err -= dy;
            y1 += sx;
        }
        if (e2 < dx) {
            err += dx;
            x1 += sy;
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


void clear_screen()
{
    map_vram(0);
    SCREEN[0][0] = 0;
    zvb_dma_start_transfer(&dma_descriptor);
}


int main()
{
    vid_mode = 2;
    map_vram(0);
    for (;;) {frame();} //Mainloop
    return 0;
}
