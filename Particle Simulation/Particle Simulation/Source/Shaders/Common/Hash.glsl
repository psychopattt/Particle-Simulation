uvec4 PCG4D(uvec4 seed)
{
    seed = seed * 1664525u + 1013904223u;
    seed.x += seed.y * seed.w;
    seed.y += seed.z * seed.x;
    seed.z += seed.x * seed.y;
    seed.w += seed.y * seed.z;
    seed ^= seed >> 16u;
    seed.x += seed.y * seed.w;
    seed.y += seed.z * seed.x;
    seed.z += seed.x * seed.y;
    seed.w += seed.y * seed.z;

    return seed;
}

uvec4 GenerateRandom(float seed1, float seed2)
{
    uint seedX = globalSeed + frame;
    uint seedY = floatBitsToUint(seed1);
    uint seedZ = floatBitsToUint(seed2);
    uint seedW = seedY ^ seedZ;

    return PCG4D(uvec4(seedX, seedY, seedZ, seedW));
}

vec4 GenerateNormalizedRandom(float seed1, float seed2)
{
    return vec4(GenerateRandom(seed1, seed2)) * (1 / float(0xffffffffu));
}

float GenerateShade(float seed1, float seed2)
{
    return float(GenerateRandom(seed1, seed2)) * (1 / float(0xffffffffu)) - 0.5;
}
