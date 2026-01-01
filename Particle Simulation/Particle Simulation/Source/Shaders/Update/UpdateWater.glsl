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
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    float vaporizeProbability = 0.25 * (
        float(CanVaporizeWater(upLeft, randomB)) +
        float(CanVaporizeWater(upRight, randomB)) +
        float(CanVaporizeWater(downLeft, randomB)) +
        float(CanVaporizeWater(downRight, randomB))
    );

    if (randomA < vaporizeProbability)
    {
        VaporizeWater(upLeft);
        VaporizeWater(upRight);
        VaporizeWater(downLeft);
        VaporizeWater(downRight);
    }
}

void UpdateWater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    VaporizeWater(upLeft, upRight, downLeft, downRight, randomA, randomB);
    MoveLiquid(WATER, upLeft, upRight, downLeft, downRight, randomA, randomB);
}
