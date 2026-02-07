float HashVec3(vec3 seed)
{
	seed = fract(seed * 0.1031);
    seed += dot(seed, seed.zyx + 31.32);
    return fract((seed.x + seed.y) * seed.z);
}

float HashVec2(vec2 seed)
{
    return HashVec3(vec3(globalSeed + frame, seed));
}

float GenerateShade(float seed1, float seed2)
{
    return HashVec2(vec2(seed1, seed2)) - 0.5;
}
