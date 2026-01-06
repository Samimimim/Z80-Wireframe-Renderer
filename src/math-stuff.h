#ifndef MATH_STUFF_H
#define MATH_STUFF_H

//Math
typedef int16_t q8_8_t;    // 16-bit fixed point value
typedef int32_t q32_t;      // intermediate

// 3D vertex in fixed Q8.8
typedef struct {
    q8_8_t x, y, z;
} Vec3;

// 2D point in integer screen coords
typedef struct {
    int16_t x, y;
} Point2i;


typedef struct {
    Point2i sa;
    Point2i sb;
} line_t;


void frame(void);

#endif