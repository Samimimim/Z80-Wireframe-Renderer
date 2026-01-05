/*
 *  math-stuff.c - Math logic behind everything
 *
 *  Compile with ""make""  
 * 
 *
 *  Translation from Alexey Kutepov's render logic: Samael with the help of GPT-5
 *  frame() and debuging: Samael
 * 
 * 
 *  Original JS file: https://github.com/tsoding/formula/blob/main/index.js
 * 
 *  License: i don't know and care
 *
 *  Tsoding's Youtube Video: https://youtu.be/qjWkNZ0SXfo
 *
 */


#include <stdint.h>

#include "math-stuff.h"
/* --- Config / types ----------------------------------------------------- */
//Screen
#define SCREEN_WIDTH (256 -1)
#define SCREEN_HEIGHT (240 -1)
void clear_screen(void);
void draw_line(int16_t x1, int16_t y1, int16_t x2, int16_t y2);

//Math
typedef int16_t q8_8_t;    // 16-bit fixed point value
typedef int32_t q32_t;      // intermediate

#define FP_SHIFT 8
#define FP_ONE   (1 << FP_SHIFT)   //255

// Convert integer to fixed
#define I2F(i) ((q8_8_t)((i) << FP_SHIFT))
// Convert fixed to integer (floor)
#define F2I(f) ((int16_t)((f) >> FP_SHIFT))

// 3D vertex in fixed Q8.8
typedef struct {
    q8_8_t x, y, z;
} Vec3;

// 2D point in integer screen coords
typedef struct {
    int16_t x, y;
} Point2i;


/*-----------Cube Modell Data----------------------------------------*/
const Vec3 vs[] = {
    //Spitze
    { 0,       256, 0 }, // 0

    // Boden (z = +1 -> 256)
    { -255,       -256,  -256 }, // Hinten Links
    { 255,     -256,   -256 }, // Hinten Rechts
    { -255,     -256,   256 }, // Vorne Links
    { 255,    -256,   256 } // Vorne Rechts
};
const uint16_t vs_count = sizeof(vs)/sizeof(vs[0]);

const uint8_t face0[] = {1,2,0}; // Hinten
const uint8_t face1[] = {3,4,0}; // Vorne
const uint8_t face2[] = {2,4,0}; // Rechts
const uint8_t face3[] = {1,3,0}; // Links

const uint8_t * const fs[] = {
    face0, face1, face2, face3
};

const uint8_t fs_len[] = {3,3,3,3};
const uint16_t fs_count = 7;

/* --- Fixed-point helpers ------------------------------------------------ */

/* Fixed multiply: (a*b)>>FP_SHIFT */
static inline q8_8_t fmul(q8_8_t a, q8_8_t b) {
    return (q8_8_t)(((q32_t)a * (q32_t)b) >> FP_SHIFT);
}
/* Fixed divide: (a<<FP_SHIFT)/b */
static inline q8_8_t fdiv(q8_8_t a, q8_8_t b) {
    if (b == 0) return (a >= 0) ? INT16_MAX : INT16_MIN;
    return (q8_8_t)(((q32_t)a << FP_SHIFT) / (q32_t)b);
}

/* --- State --------------------------------------------------------------- */

static q8_8_t dz = I2F(3);   // initial translate in z (1.0)
static uint8_t angle = 0;    // 0-255 full circle

static const uint8_t ANGLE_STEP = 16u;

static const q8_8_t sin_lut[256] = {
    0, 3, 6, 9, 12, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46,
    49, 52, 55, 58, 61, 64, 67, 70, 73, 76, 78, 81, 84, 87, 90, 93,
    95, 98,101,104,106,109,111,114,116,119,121,124,126,128,131,133,
    135,138,140,142,144,147,149,151,153,155,157,159,161,163,165,167,
    169,171,173,175,177,178,180,182,184,185,187,189,190,192,194,195,
    197,198,200,201,203,204,206,207,208,210,211,212,214,215,216,218,
    219,220,221,223,224,225,226,227,228,229,231,232,233,234,234,235,
    236,237,238,239,240,241,241,242,243,243,244,245,245,246,246,247,
    247,248,248,249,249,250,250,250,251,251,251,252,252,252,252,253,
    253,253,253,254,254,254,254,254,254,255,255,255,255,255,255,255,
    255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
    255,254,254,254,254,254,254,253,253,253,253,252,252,252,252,251,
    251,251,250,250,250,249,249,248,248,247,247,246,246,245,245,244,
    243,243,242,241,241,240,239,238,237,236,235,234,234,233,232,231,
    229,228,227,226,225,224,223,221,220,219,218,216,215,214,212,211,
    210,208,207,206,204,203,201,200,198,197,195,194,192,190,189,187,
    185,184,182,181,178,177,175,173,171,169,167,165,163,161,159,157,
    155,153,151,149,147,144,142,140,138,135,133,131,128,126,124,121,
    119,116,114,111,109,106,104,101, 98, 95, 93, 90, 87, 84, 81, 78,
     76, 73, 70, 67, 64, 61, 58, 55, 52, 49, 46, 43, 40, 37, 34, 31,
     28, 25, 22, 19, 16, 12,  9,  6,  3,  0
};

static const q8_8_t cos_lut[256] = {
    256, 256, 256, 255, 255, 255, 254, 254, 254, 254, 254, 254, 253, 253, 253, 253,
    252, 252, 252, 252, 251, 251, 251, 250, 250, 250, 249, 249, 248, 248, 247, 247,
    246, 246, 245, 245, 244, 243, 243, 242, 241, 241, 240, 239, 238, 237, 236, 235,
    234, 234, 233, 232, 231, 229, 228, 227, 226, 225, 224, 223, 221, 220, 219, 218,
    216, 215, 214, 212, 211, 210, 208, 207, 206, 204, 203, 201, 200, 198, 197, 195,
    194, 192, 190, 189, 187, 185, 184, 182, 181, 178, 177, 175, 173, 171, 169, 167,
    165, 163, 161, 159, 157, 155, 153, 151, 149, 147, 144, 142, 140, 138, 135, 133,
    131, 128, 126, 124, 121, 119, 116, 114, 111, 109, 106, 104, 101,  98,  95,  93,
     90,  87,  84,  81,  78,  76,  73,  70,  67,  64,  61,  58,  55,  52,  49,  46,
     43,  40,  37,  34,  31,  28,  25,  22,  19,  16,  12,   9,   6,   3,   0,   0,
     0,   3,   6,   9,  12,  16,  19,  22,  25,  28,  31,  34,  37,  40,  43,  46,
     49,  52,  55,  58,  61,  64,  67,  70,  73,  76,  78,  81,  84,  87,  90,  93,
     95,  98, 101, 104, 106, 109, 111, 114, 116, 119, 121, 124, 126, 128, 131, 133,
    135, 138, 140, 142, 144, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167,
    169, 171, 173, 175, 177, 178, 180, 182, 184, 185, 187, 189, 190, 192, 194, 195,
    197, 198, 200, 201, 203, 204, 206, 207, 208, 210, 211, 212, 214, 215, 216, 218
};

static void lut_rot(uint8_t a, q8_8_t *out_cos, q8_8_t *out_sin) {
    *out_cos = cos_lut[a]; // Q8.8
    *out_sin = sin_lut[a]; // Q8.8
}
/*-----------Operations------------------------------*/

// rotate_xz_out: rotate vector in XZ plane by angle a (0-255)
static void rotate_xz_out(const Vec3 *v, uint8_t a, Vec3 *out) {
    q8_8_t c, s;
    lut_rot(a, &c, &s);
    // x*c - z*s ; x*s + z*c
    q32_t tx = (q32_t)fmul(v->x, c) - (q32_t)fmul(v->z, s);
    q32_t tz = (q32_t)fmul(v->x, s) + (q32_t)fmul(v->z, c);
    out->x = (q8_8_t)tx;
    out->y = v->y;
    out->z = (q8_8_t)tz;
}

// translate_z_out: add addz to z
static void translate_z_out(const Vec3 *v, q8_8_t addz, Vec3 *out) {
    *out = *v;
    out->z = (q8_8_t)((q32_t)out->z + (q32_t)addz);
}

// project_out: simple perspective divide (produces Q8.8 x/y, passes z through)
static void project_out(const Vec3 *v, Vec3 *out) {
    const q8_8_t Z_MIN = I2F(2);
    q8_8_t z = v->z;
    if (z < Z_MIN) z = Z_MIN;

    out->x = fdiv(v->x, z); /* (x_fixed << SHIFT)/z_fixed -> Q8.8 */
    out->y = fdiv(v->y, z); //This is the Algorithm im here for!!!!!!
    out->z = z;
}

static void screen_point_out(const Vec3 *p, Point2i *out) {
    // Map x from [-1..1] (Q8.8) to [0..SCREEN_WIDTH)
    q32_t px = (q32_t)p->x + (q32_t)FP_ONE; // shift -1..+1 -> 0..2 in Q8.8
    int32_t sx = (int32_t)((px * (q32_t)SCREEN_WIDTH) / (2 * (q32_t)FP_ONE));

    // Map y from [-1..1] (Q8.8) to [0..SCREEN_HEIGHT), flipping Y
    q32_t py = (q32_t)p->y;
    // convert p->y (Q8.8, -1..+1) to screen: center -> FP_ONE maps to 0.5, so adjust
    int32_t sy = (int32_t)((( ( (q32_t)FP_ONE - (py + (q32_t)FP_ONE) / 2 ) * (q32_t)SCREEN_HEIGHT) ) / (q32_t)FP_ONE);

    out->x = (int16_t)sx;
    out->y = (int16_t)sy;
}

static inline void clamp_proj(Vec3 *p) {
    if (p->x < -FP_ONE) p->x = -FP_ONE;
    if (p->x >  FP_ONE) p->x =  FP_ONE;
    if (p->y < -FP_ONE) p->y = -FP_ONE;
    if (p->y >  FP_ONE) p->y =  FP_ONE;
}


void frame(void) {
    // increment angle
    angle = (uint8_t)(angle + ANGLE_STEP);

    clear_screen(); //Slow as hell, but what are you gonna do about it?

    // For each face, draw its edges 
    for (uint16_t fi = 0; fi < fs_count; ++fi) {
        const uint8_t *face = fs[fi];
        uint8_t len = fs_len[fi];
        if (len < 2) continue;

        for (uint8_t i = 0; i < len; ++i) {
            uint8_t idx_a = face[i];
            uint8_t idx_b = face[(i + 1) % len];
            if (idx_a >= vs_count || idx_b >= vs_count) continue;

            // get vertices 
            Vec3 va;
            Vec3 vb;
            va = vs[idx_a];
            vb = vs[idx_b];

            // rotate, translate, project, screen 
            Vec3 ra, pa, rb, pb;
            Point2i sa, sb;
            
            rotate_xz_out(&va, angle, &ra);
            translate_z_out(&ra, dz, &ra);
            project_out(&ra, &pa);
            clamp_proj(&pa);
            screen_point_out(&pa, &sa);

            rotate_xz_out(&vb, angle, &rb);
            translate_z_out(&rb, dz, &rb);
            project_out(&rb, &pb);
            clamp_proj(&pb);
            screen_point_out(&pb, &sb);

            draw_line(sa.x, sa.y, sb.x, sb.y);
        }
    }
}