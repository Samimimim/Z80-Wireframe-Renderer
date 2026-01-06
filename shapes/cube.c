const Vec3 vs[] = {
    {-128,-128,-128}, // 0
    { 128,-128,-128}, // 1
    { 128, 128,-128}, // 2
    {-128, 128,-128}, // 3
    {-128,-128, 128}, // 4
    { 128,-128, 128}, // 5
    { 128, 128, 128}, // 6
    {-128, 128, 128}  // 7
};

Point2i vs_buffer[sizeof(vs)/sizeof(vs[0])];
const uint16_t vs_count = sizeof(vs)/sizeof(vs[0]);

const uint8_t face0[] = {0,1,2,3}; // back
const uint8_t face1[] = {4,5,6,7}; // front
const uint8_t face2[] = {0,1,5,4}; // bottom
const uint8_t face3[] = {3,2,6,7}; // top
const uint8_t face4[] = {0,3,7,4}; // left
const uint8_t face5[] = {1,2,6,5}; // right

const uint8_t * const fs[] = {
    face0, face1, face2, face3, face4, face5
};

const uint8_t fs_len[] = {
    4,4,4,4,4,4
};

const uint16_t fs_count = 6;
