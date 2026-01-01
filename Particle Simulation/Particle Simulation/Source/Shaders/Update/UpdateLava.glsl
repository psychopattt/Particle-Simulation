bool CanSolidifyLava(Particle particle, float random)
{
    switch (particle.type)
    {
        case WATER: return random < 0.18;
        case FIRE: return false;
        case SEAWATER: return random < 0.18;
        case LAVA: return false;
        default: return random < 0.003;
    }
}

bool CanMeltIntoLava(Particle particle, float random)
{
    switch (particle.type)
    {
        case STONE: return random < 0.12;
        case SALT: return random < 0.17;
        case RUST: return random < 0.06;
        default: return false;
    }
}

bool SolidifyLava(inout Particle particle, float probability, float random)
{
    bool solidified = particle.type == LAVA && random < probability;

    if (solidified)
        particle = CreateParticle(STONE, particle.shade);

    return solidified;
}

void SolidifyLava(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomC)
{
    float probability = 0.25 * (
        float(CanSolidifyLava(upLeft, randomC)) +
        float(CanSolidifyLava(upRight, randomC)) +
        float(CanSolidifyLava(downLeft, randomC)) +
        float(CanSolidifyLava(downRight, randomC))
    );

    bool solidified = SolidifyLava(upLeft, probability * 0.25, randomA);
    solidified = solidified || SolidifyLava(upRight, probability * 0.5, randomA);
    solidified = solidified || SolidifyLava(downLeft, probability * 0.75, randomA);
    solidified = solidified || SolidifyLava(downRight, probability, randomA);
}

void UpdateLavaShade(inout Particle particle, float random)
{
    if (particle.type == LAVA)
        particle.shade = HashVec2(vec2(random, particle.shade)) - 0.5;
}

void UpdateLavaShade(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (random < 0.01)
    {
        UpdateLavaShade(upLeft, random);
        UpdateLavaShade(upRight, random);
        UpdateLavaShade(downLeft, random);
        UpdateLavaShade(downRight, random);
    }
}

void MeltParticleIntoLava(inout Particle particle, float random)
{
    if (CanMeltIntoLava(particle, random))
        particle = CreateParticle(LAVA, particle.shade);
}

void MeltParticlesIntoLava(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    float meltProbability = 0.01 * (
        float(upLeft.type == LAVA) + float(upRight.type == LAVA) +
        float(downLeft.type == LAVA) + float(downRight.type == LAVA)
    );

    if (randomB < meltProbability)
    {
        MeltParticleIntoLava(upLeft, randomA);
        MeltParticleIntoLava(upRight, randomA);
        MeltParticleIntoLava(downLeft, randomA);
        MeltParticleIntoLava(downRight, randomA);
    }
}

void UpdateLava(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    SolidifyLava(upLeft, upRight, downLeft, downRight, randomA, randomC);
    UpdateLavaShade(upLeft, upRight, downLeft, downRight, randomA);
    MeltParticlesIntoLava(upLeft, upRight, downLeft, downRight, randomA, randomB);
    MoveLiquid(LAVA, upLeft, upRight, downLeft, downRight, randomA, randomB);
}
