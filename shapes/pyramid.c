const Vec3 vs[] = {
    //top
    { 0,    256,  0  }, // 0
    // bottom 
    {-255, -256, -256},// rear left
    { 255, -256, -256},// rear right
    {-255, -256,  256},// front left
    { 255, -256,  256} // front right
};
//The pipeline will first calculate the possition of the points, and then draw the lines
Point2i vs_buffer[sizeof(vs)/sizeof(vs[0])];

const uint16_t vs_count = sizeof(vs)/sizeof(vs[0]);

const uint8_t face0[] = {1,2,0}; // rear
const uint8_t face1[] = {3,4,0}; // front
const uint8_t face2[] = {1,2,4,3}; // bottom

const uint8_t * const fs[] = {
    face0, face1, face2
};

const uint8_t fs_len[] = {3,3,4};
const uint16_t fs_count = 3;