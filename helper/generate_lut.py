import math

Q = 8          # Q8.8
SCALE = 1 << Q
SIZE = 256

def to_q8_8(x):
    return int(round(x * SCALE))

sin_lut = []
cos_lut = []

for i in range(SIZE):
    angle = 2 * math.pi * i / SIZE
    sin_lut.append(to_q8_8(math.sin(angle)))
    cos_lut.append(to_q8_8(math.cos(angle)))

def print_c_array(name, data):
    print(f"static const q8_8_t {name}[256] = {{")
    for i in range(0, 256, 8):
        line = ", ".join(f"{v:4d}" for v in data[i:i+8])
        print("    " + line + ",")
    print("};\n")

print_c_array("sin_lut", sin_lut)
print_c_array("cos_lut", cos_lut)
