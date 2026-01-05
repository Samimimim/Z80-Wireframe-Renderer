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
//FETRTIG!!!!                                                    [x]


/*
 * +---------Current Problem----------------+
 * |                                        |
 * |      Cube stops rotating at            |
 * |         some point                     |  
 * |                                        |
 * +----------------------------------------+
*/

#include <stdint.h>
#include "math-stuff.h"

#define SCREEN_WIDTH 256
#define SCREEN_HEIGHT 240
#define display_OF 0 
#define display_ON 1<<7
uint8_t current_page;
__sfr __at(0xF2) mmu_page2;
__sfr __banked __at(0x9C) vid_mode;
__sfr __banked __at(0x9D) vid_stat;
uint8_t __at(0x8000) SCREEN[SCREEN_HEIGHT][SCREEN_WIDTH];
static int abs(int v) { return v < 0 ? -v : v; } //How said  i don't have abs?

static inline void map_vram(uint8_t page) //Page is relative to tileset memory
{
    __asm__("di"); //No need to interupt me, dear Computer
    current_page = page;
    //((VID_MEM_PHYS_ADDR_START + 64 * 1024) >> 14); //This gives a Warning so i hardcode it to 68
    mmu_page2 = 68 + page;
}

void screen_write(int x, int y, uint8_t color)
{
    uint16_t index;
    uint8_t page;

    index = y * SCREEN_WIDTH + x;
    page  = index >> 14; //Page that is required for write

    if (page != current_page) {
        map_vram(page);
    }

    ((uint8_t*)0x8000)[index & 0x3FFF] = color;
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
    int size = 2;
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

void fill_screen(uint8_t color)
{
    int x, y;
    for (y = 0; y < SCREEN_HEIGHT; y++) {
        for (x = 0; x < SCREEN_WIDTH; x++) {
            screen_write(x, y, color);
        }
    }
}

void clear_screen() {
   int x, y;
    for (y = 44; y < 196; y++) {
        for (x = 59; x < 197; x++) {
            screen_write(x, y, 0);
        }
    }
}

int main()
{
    vid_mode = 2;
    map_vram(0);
    for (;;) {frame();} //Mainloop
    //Just for testing
    return 0;
}
