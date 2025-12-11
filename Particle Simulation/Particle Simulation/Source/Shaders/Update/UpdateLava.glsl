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

bool IsMovableByLava(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.9;
        case WATER: return random < 0.21;
        case SMOKE: return random < 0.68;
        case FIRE: return random < 0.6;
        case KEROSENE: return random < 0.24;
        case STEAM: return random < 0.7;
        case SEAWATER: return random < 0.21;
        case ACID: return random < 0.28;
        case METHANE: return random < 0.69;
        case AMMONIA: return random < 0.69;
        default: return false;
    }
}

bool SolidifyLava(inout Particle particle, float probability, float random)
{
    bool solidified = particle.type == LAVA && random < probability;

    if (solidified)
        particle.type = STONE;

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
        particle.type = LAVA;
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

void MoveLavaDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    if (upLeft.type == LAVA)
    {
        if (IsMovableByLava(downLeft, random))
        {
            leftFell = true;
            SwapParticles(upLeft, downLeft);
        }
        else if (IsMovableByLava(upRight, random) && IsMovableByLava(downRight, random))
        {
            SwapParticles(upLeft, downRight);
        }
    }

    if (upRight.type == LAVA)
    {
        if (IsMovableByLava(downRight, random))
        {
            rightFell = true;
            SwapParticles(upRight, downRight);
        }
        else if (IsMovableByLava(upLeft, random) && IsMovableByLava(downLeft, random))
        {
            SwapParticles(upRight, downLeft);
        }
    }
}

void MoveLavaLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomB, float randomC, bool leftFell, bool rightFell)
{
    if (randomB < 0.8 &&
        ((upLeft.type == LAVA && IsMovableByLava(upRight, randomC) && !leftFell) ||
        (upRight.type == LAVA && IsMovableByLava(upLeft, randomC) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (randomB < 0.5 &&
        ((downLeft.type == LAVA && IsMovableByLava(downRight, randomC) && !leftFell) ||
        (downRight.type == LAVA && IsMovableByLava(downLeft, randomC) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdateLava(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    SolidifyLava(upLeft, upRight, downLeft, downRight, randomA, randomC);
    UpdateLavaShade(upLeft, upRight, downLeft, downRight, randomA);
    MeltParticlesIntoLava(upLeft, upRight, downLeft, downRight, randomA, randomB);

    bool leftFell = false;
    bool rightFell = false;
    MoveLavaDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveLavaLaterally(upLeft, upRight, downLeft, downRight, randomB, randomC, leftFell, rightFell);
}
