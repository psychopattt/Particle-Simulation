bool CanVaporizeWater(Particle particle, float random)
{
    switch (particle.type)
    {
        case FIRE: return random < 0.014;
        case LAVA: return random < 0.07;
        default: return false;
    }
}

void VaporizeWater(inout Particle particle)
{
    if (particle.type == WATER)
        particle = CreateParticle(STEAM, particle.shade);
}

void VaporizeWater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float vaporizeProbability = 0.25 * (
        float(CanVaporizeWater(upLeft, random.y)) +
        float(CanVaporizeWater(upRight, random.y)) +
        float(CanVaporizeWater(downLeft, random.y)) +
        float(CanVaporizeWater(downRight, random.y))
    );

    if (random.x < vaporizeProbability)
    {
        VaporizeWater(upLeft);
        VaporizeWater(upRight);
        VaporizeWater(downLeft);
        VaporizeWater(downRight);
    }
}

void UpdateWater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    VaporizeWater(upLeft, upRight, downLeft, downRight, random);
    MoveLiquid(WATER, upLeft, upRight, downLeft, downRight, random);
}
