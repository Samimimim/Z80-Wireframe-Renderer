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
#include "zos_time.h"
#include "math-stuff.h"
/* --- Config / types ----------------------------------------------------- */
//Screen
#define SCREEN_WIDTH 256
#define SCREEN_HEIGHT 240
#define SCREEN_ON 1<<7
#define SCREEN_OFF 0
void clear_screen(void);
void draw_line(int16_t x1, int16_t y1, int16_t x2, int16_t y2);
void display_state(uint8_t state);

//Math
typedef int16_t q8_8_t;    // 16-bit fixed point value
typedef int32_t q32_t;      // intermediate

#define FP_SHIFT 8
#define FP_ONE   (1 << FP_SHIFT)   //256

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
    //top
    { 0,       256, 0 }, // 0

    // bottom (z = +1 -> 256)
    { -255,       -256,  -256 }, // rear left
    { 255,     -256,   -256 }, // rear right
    { -255,     -256,   256 }, // front left
    { 255,    -256,   256 } // front right
};
const uint16_t vs_count = sizeof(vs)/sizeof(vs[0]);

const uint8_t face0[] = {1,2,0}; // rear
const uint8_t face1[] = {3,4,0}; // front
const uint8_t face2[] = {1,2,4,3}; // bottom

const uint8_t * const fs[] = {
    face0, face1, face2
};

const uint8_t fs_len[] = {3,3,4};
const uint16_t fs_count = 3;

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

static const uint8_t ANGLE_STEP = 2u;

static const q8_8_t sin_lut[256] = {
       0,    6,   13,   19,   25,   31,   38,   44,
      50,   56,   62,   68,   74,   80,   86,   92,
      98,  104,  109,  115,  121,  126,  132,  137,
     142,  147,  152,  157,  162,  167,  172,  177,
     181,  185,  190,  194,  198,  202,  206,  209,
     213,  216,  220,  223,  226,  229,  231,  234,
     237,  239,  241,  243,  245,  247,  248,  250,
     251,  252,  253,  254,  255,  255,  256,  256,
     256,  256,  256,  255,  255,  254,  253,  252,
     251,  250,  248,  247,  245,  243,  241,  239,
     237,  234,  231,  229,  226,  223,  220,  216,
     213,  209,  206,  202,  198,  194,  190,  185,
     181,  177,  172,  167,  162,  157,  152,  147,
     142,  137,  132,  126,  121,  115,  109,  104,
      98,   92,   86,   80,   74,   68,   62,   56,
      50,   44,   38,   31,   25,   19,   13,    6,
       0,   -6,  -13,  -19,  -25,  -31,  -38,  -44,
     -50,  -56,  -62,  -68,  -74,  -80,  -86,  -92,
     -98, -104, -109, -115, -121, -126, -132, -137,
    -142, -147, -152, -157, -162, -167, -172, -177,
    -181, -185, -190, -194, -198, -202, -206, -209,
    -213, -216, -220, -223, -226, -229, -231, -234,
    -237, -239, -241, -243, -245, -247, -248, -250,
    -251, -252, -253, -254, -255, -255, -256, -256,
    -256, -256, -256, -255, -255, -254, -253, -252,
    -251, -250, -248, -247, -245, -243, -241, -239,
    -237, -234, -231, -229, -226, -223, -220, -216,
    -213, -209, -206, -202, -198, -194, -190, -185,
    -181, -177, -172, -167, -162, -157, -152, -147,
    -142, -137, -132, -126, -121, -115, -109, -104,
     -98,  -92,  -86,  -80,  -74,  -68,  -62,  -56,
     -50,  -44,  -38,  -31,  -25,  -19,  -13,   -6,
};

static const q8_8_t cos_lut[256] = {
     256,  256,  256,  255,  255,  254,  253,  252,
     251,  250,  248,  247,  245,  243,  241,  239,
     237,  234,  231,  229,  226,  223,  220,  216,
     213,  209,  206,  202,  198,  194,  190,  185,
     181,  177,  172,  167,  162,  157,  152,  147,
     142,  137,  132,  126,  121,  115,  109,  104,
      98,   92,   86,   80,   74,   68,   62,   56,
      50,   44,   38,   31,   25,   19,   13,    6,
       0,   -6,  -13,  -19,  -25,  -31,  -38,  -44,
     -50,  -56,  -62,  -68,  -74,  -80,  -86,  -92,
     -98, -104, -109, -115, -121, -126, -132, -137,
    -142, -147, -152, -157, -162, -167, -172, -177,
    -181, -185, -190, -194, -198, -202, -206, -209,
    -213, -216, -220, -223, -226, -229, -231, -234,
    -237, -239, -241, -243, -245, -247, -248, -250,
    -251, -252, -253, -254, -255, -255, -256, -256,
    -256, -256, -256, -255, -255, -254, -253, -252,
    -251, -250, -248, -247, -245, -243, -241, -239,
    -237, -234, -231, -229, -226, -223, -220, -216,
    -213, -209, -206, -202, -198, -194, -190, -185,
    -181, -177, -172, -167, -162, -157, -152, -147,
    -142, -137, -132, -126, -121, -115, -109, -104,
     -98,  -92,  -86,  -80,  -74,  -68,  -62,  -56,
     -50,  -44,  -38,  -31,  -25,  -19,  -13,   -6,
       0,    6,   13,   19,   25,   31,   38,   44,
      50,   56,   62,   68,   74,   80,   86,   92,
      98,  104,  109,  115,  121,  126,  132,  137,
     142,  147,  152,  157,  162,  167,  172,  177,
     181,  185,  190,  194,  198,  202,  206,  209,
     213,  216,  220,  223,  226,  229,  231,  234,
     237,  239,  241,  243,  245,  247,  248,  250,
     251,  252,  253,  254,  255,  255,  256,  256,
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
    
    msleep(250);
    display_state(SCREEN_OFF);
    clear_screen();
    display_state(SCREEN_ON);
    
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