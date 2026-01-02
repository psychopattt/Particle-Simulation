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
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float vaporizeProbability = 0.25 * (
        float(CanVaporizeSeawater(upLeft, random.y)) +
        float(CanVaporizeSeawater(upRight, random.y)) +
        float(CanVaporizeSeawater(downLeft, random.y)) +
        float(CanVaporizeSeawater(downRight, random.y))
    );

    if (random.x < vaporizeProbability)
    {
        VaporizeSeawater(upLeft);
        VaporizeSeawater(upRight);
        VaporizeSeawater(downLeft);
        VaporizeSeawater(downRight);
    }
}

void UpdateSeawater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    VaporizeSeawater(upLeft, upRight, downLeft, downRight, random);
    MoveLiquid(SEAWATER, upLeft, upRight, downLeft, downRight, random);
}
