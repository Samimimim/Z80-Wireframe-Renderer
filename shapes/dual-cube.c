const Vec3 vs[] = {
    // äußerer Würfel (Kantenlänge 512)
    {-256,-256,-256}, // 0
    { 256,-256,-256}, // 1
    { 256, 256,-256}, // 2
    {-256, 256,-256}, // 3
    {-256,-256, 256}, // 4
    { 256,-256, 256}, // 5
    { 256, 256, 256}, // 6
    {-256, 256, 256}, // 7

    // innerer Würfel (Kantenlänge 128)
    {-64,-64,-64}, // 8
    { 64,-64,-64}, // 9
    { 64, 64,-64}, // 10
    {-64, 64,-64}, // 11
    {-64,-64, 64}, // 12
    { 64,-64, 64}, // 13
    { 64, 64, 64}, // 14
    {-64, 64, 64}  // 15
};

Point2i vs_buffer[sizeof(vs)/sizeof(vs[0])];
const uint16_t vs_count = sizeof(vs)/sizeof(vs[0]);

// äußerer Würfel
const uint8_t face0[] = {0,1,2,3}; // back
const uint8_t face1[] = {4,5,6,7}; // front
const uint8_t face2[] = {0,1,5,4}; // bottom
const uint8_t face3[] = {3,2,6,7}; // top
const uint8_t face4[] = {0,3,7,4}; // left
const uint8_t face5[] = {1,2,6,5}; // right

// innerer Würfel
const uint8_t face6[]  = { 8, 9,10,11};
const uint8_t face7[]  = {12,13,14,15};
const uint8_t face8[]  = { 8, 9,13,12};
const uint8_t face9[]  = {11,10,14,15};
const uint8_t face10[] = { 8,11,15,12};
const uint8_t face11[] = { 9,10,14,13};

const uint8_t * const fs[] = {
    face0, face1, face2, face3, face4, face5,
    face6, face7, face8, face9, face10, face11
};

const uint8_t fs_len[] = {
    4,4,4,4,4,4,
    4,4,4,4,4,4
};

const uint16_t fs_count = 12;