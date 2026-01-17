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
        case ROCK: return random < 0.12;
        case SALT: return random < 0.17;
        case RUST: return random < 0.06;
        default: return false;
    }
}

bool SolidifyLava(inout Particle particle, float probability, float random)
{
    bool solidified = particle.type == LAVA && random < probability;

    if (solidified)
        particle = CreateParticle(ROCK, particle.shade);

    return solidified;
}

void SolidifyLava(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float probability = 0.25 * (
        float(CanSolidifyLava(upLeft, random.z)) +
        float(CanSolidifyLava(upRight, random.z)) +
        float(CanSolidifyLava(downLeft, random.z)) +
        float(CanSolidifyLava(downRight, random.z))
    );

    bool solid = SolidifyLava(upLeft, probability * 0.25, random.x);
    solid = solid || SolidifyLava(upRight, probability * 0.5, random.x);
    solid = solid || SolidifyLava(downLeft, probability * 0.75, random.x);
    solid = solid || SolidifyLava(downRight, probability, random.x);
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
        particle = CreateParticle(LAVA, 0);
}

void MeltParticlesIntoLava(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float meltProbability = 0.01 * (
        float(upLeft.type == LAVA) + float(upRight.type == LAVA) +
        float(downLeft.type == LAVA) + float(downRight.type == LAVA)
    );

    if (random.y < meltProbability)
    {
        MeltParticleIntoLava(upLeft, random.x);
        MeltParticleIntoLava(upRight, random.x);
        MeltParticleIntoLava(downLeft, random.x);
        MeltParticleIntoLava(downRight, random.x);
    }
}

void UpdateLava(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    SolidifyLava(upLeft, upRight, downLeft, downRight, random);
    UpdateLavaShade(upLeft, upRight, downLeft, downRight, random.x);
    MeltParticlesIntoLava(upLeft, upRight, downLeft, downRight, random);
    MoveLiquid(LAVA, upLeft, upRight, downLeft, downRight, random);
}
