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
#define SCREEN_WIDTH 256 -1
#define SCREEN_HEIGHT 240 -1
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
    // Lower layer
    { I2F(-1), I2F(-1), I2F(-1) }, /* 0 Hinten Links*/ 
    { I2F( 1), I2F(-1), I2F(-1) }, /* 1 Hinten Rechts*/
    { I2F( 1), I2F( 1), I2F(-1) }, /* 2 Vorne Rechts*/
    { I2F(-1), I2F( 1), I2F(-1) }, /* 3 Vorne Links*/
    // upper layer
    { I2F(-1), I2F(-1), I2F( 1) }, /* 4 Hinten Links*/
    { I2F( 1), I2F(-1), I2F( 1) }, /* 5 Hinten Rechts*/
    { I2F( 1), I2F( 1), I2F( 1) }, /* 6 Vorne Rechts*/
    { I2F(-1), I2F( 1), I2F( 1) }  /* 7 Vorne Links*/
};

const uint16_t vs_count = (uint16_t)(sizeof(vs) / sizeof(vs[0]));

// Faces
const uint8_t face0[] = { 0, 1, 2, 3 }; /* bottom */
const uint8_t face1[] = { 4, 5, 6, 7 }; /* top */
const uint8_t face2[] = { 0, 1, 5, 4 }; /* front */
const uint8_t face3[] = { 2, 3, 7, 6 }; /* back */
const uint8_t face4[] = { 1, 2, 6, 5 }; /* right */
const uint8_t face5[] = { 0, 3, 7, 4 }; /* left */

// Pointer array to faces
const uint8_t * const fs[] = {
    face0,
    face1,
    face2,
    face3,
    face4,
    face5
};

// SDCC-friendly explicit lengths (all faces are quads here)
const uint8_t fs_len[] = { 4, 4, 4, 4, 4, 4 };

//face count
const uint16_t fs_count = 6;

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

static q8_8_t dz = I2F(1)*3;   // initial translate in z (1.0)
static uint8_t angle = 0;    // 0-255 full circle

static const uint8_t ANGLE_STEP = 2u;

static const int8_t cordic_atan[] = { 32, 19, 10, 5, 3, 1, 1, 0 };

/* CORDIC gain K ~ 0.607252935 => in Q8.8 */
#define CORDIC_K 155 /* (int)(0.607252935 * 256) ~= 155 */

static void cordic_rot(uint8_t a, q8_8_t *out_cos, q8_8_t *out_sin) {
    /* Map angle 0..255 to signed range -128..127 to represent -pi..pi */
    int16_t z = (int16_t)a;
    if (z > 127) z -= 256;

    /* working vars in Q8.8 */
    q32_t x = CORDIC_K; /* Q8.8 */
    q32_t y = 0;
    int i;
    for (i = 0; i < (int)(sizeof(cordic_atan)/sizeof(cordic_atan[0])); ++i) {
        int16_t shift = i;
        int16_t zstep = cordic_atan[i];
        if (z >= 0) {
            /* rotate by +atan(2^-i) */
            q32_t x_new = x - (y >> shift);
            q32_t y_new = y + (x >> shift);
            x = x_new; y = y_new;
            z -= zstep;
        } else {
            q32_t x_new = x + (y >> shift);
            q32_t y_new = y - (x >> shift);
            x = x_new; y = y_new;
            z += zstep;
        }
    }
    /* results are in Q8.8 */
    *out_cos = (q8_8_t)x;
    *out_sin = (q8_8_t)y;
}

/*-----------Operations------------------------------*/

// rotate_xz_out: rotate vector in XZ plane by angle a (0-255)
static void rotate_xz_out(const Vec3 *v, uint8_t a, Vec3 *out) {
    q8_8_t c, s;
    cordic_rot(a, &c, &s);
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
    const q8_8_t Z_MIN = 2;
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