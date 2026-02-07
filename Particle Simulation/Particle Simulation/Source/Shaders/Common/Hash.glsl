float HashVec3(vec3 seed)
{
    seed = fract(seed * 0.1031);
    seed += dot(seed, seed.zyx + 33.33);
    return fract((seed.x + seed.y) * seed.z);
}

float HashVec2(vec2 seed)
{
    float frameSeed = mod(globalSeed + frame, 200000);
    return HashVec3(vec3(frameSeed, seed));
}

float GenerateShade(float seed1, float seed2)
{
    return HashVec2(vec2(seed1, seed2)) - 0.5;
}
