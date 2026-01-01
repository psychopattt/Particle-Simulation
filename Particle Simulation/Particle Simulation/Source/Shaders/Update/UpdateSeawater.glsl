bool CanVaporizeSeawater(Particle particle, float random)
{
    switch (particle.type)
    {
        case FIRE: return random < 0.0144;
        case LAVA: return random < 0.072;
        default: return false;
    }
}

void VaporizeSeawater(inout Particle particle)
{
    if (particle.type == SEAWATER)
        particle = CreateParticle(STEAM, particle.shade);
}

void VaporizeSeawater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    float vaporizeProbability = 0.25 * (
        float(CanVaporizeSeawater(upLeft, randomB)) +
        float(CanVaporizeSeawater(upRight, randomB)) +
        float(CanVaporizeSeawater(downLeft, randomB)) +
        float(CanVaporizeSeawater(downRight, randomB))
    );

    if (randomA < vaporizeProbability)
    {
        VaporizeSeawater(upLeft);
        VaporizeSeawater(upRight);
        VaporizeSeawater(downLeft);
        VaporizeSeawater(downRight);
    }
}

void UpdateSeawater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    VaporizeSeawater(upLeft, upRight, downLeft, downRight, randomA, randomB);
    MoveLiquid(SEAWATER, upLeft, upRight, downLeft, downRight, randomA, randomB);
}
