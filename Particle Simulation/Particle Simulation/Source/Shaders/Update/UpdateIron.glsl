bool CanRustIron(Particle particle, float random)
{
    switch (particle.type)
    {
        case WATER: return random < 0.006;
        case STEAM: return random < 0.004;
        case SEAWATER: return random < 0.013;
        case SALT: return random < 0.0006;
        default: return false;
    }
}

bool RustIron(inout Particle particle, float probability, float random)
{
    bool rusted = particle.type == IRON && random < probability;

    if (rusted)
        particle = CreateParticle(RUST, particle.shade);

    return rusted;
}

void RustIron(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    float probability = 0.3 * (
        float(CanRustIron(upLeft, randomB)) +
        float(CanRustIron(upRight, randomB)) +
        float(CanRustIron(downLeft, randomB)) +
        float(CanRustIron(downRight, randomB))
    );

    bool rusted = RustIron(upLeft, probability * 0.25, randomA);
    rusted = rusted || RustIron(upRight, probability * 0.5, randomA);
    rusted = rusted || RustIron(downLeft, probability * 0.75, randomA);
    rusted = rusted || RustIron(downRight, probability, randomA);
}

void UpdateIron(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    RustIron(upLeft, upRight, downLeft, downRight, randomA, randomB);
}
