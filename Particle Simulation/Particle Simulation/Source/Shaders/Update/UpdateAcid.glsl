bool IsDissolvableByAcid(Particle particle, float random)
{
    switch (particle.type)
    {
        case SAND: return random < 0.002;
        case WATER: return random < 0.017;
        case WOOD: return random < 0.034;
        case STONE: return random < 0.005;
        case KEROSENE: return random < 0.012;
        case STEAM: return random < 0.0187;
        case SEAWATER: return random < 0.0154;
        case LAVA: return random < 0.007;
        case ICE: return random < 0.0124;
        case SALT: return random < 0.008;
        case SAWDUST: return random < 0.074;
        case VINE: return random < 0.059;
        case RUST: return random < 0.01;
        case IRON: return random < 0.006;
        default: return false;
    }
}

bool IsMovableByAcid(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return true;
        case WATER: return random < 0.285;
        case SMOKE: return true;
        case KEROSENE: return random < 0.55;
        case STEAM: return true;
        case SEAWATER: return random < 0.28;
        default: return false;
    }
}

void DissolveParticleByAcid(inout Particle particle, float random)
{
    if (IsDissolvableByAcid(particle, random))
        particle.type = IsDissolvableByAcid(particle, random * 8) ? SMOKE : VOID;
}

void DissolveParticlesByAcid(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (upRight.type == ACID || downLeft.type == ACID)
    {
        if (randomA < 0.5)
            DissolveParticleByAcid(upLeft, randomB);
        else
            DissolveParticleByAcid(downRight, randomB);
    }

    if (upLeft.type == ACID || downRight.type == ACID)
    {
        if (randomB < 0.5)
            DissolveParticleByAcid(upRight, randomA);
        else
            DissolveParticleByAcid(downLeft, randomA);
    }
}

bool NeutralizeAcid(inout Particle particle, float probability, float random)
{
    bool neutralized = particle.type == ACID && random < probability;

    if (neutralized)
        particle.type = particle.shade > 0.44 ? SMOKE : VOID;

    return neutralized;
}

void NeutralizeAcid(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    bool allAcid = upLeft.type == ACID && upRight.type == ACID &&
        downLeft.type == ACID && downRight.type == ACID;

    if (allAcid)
        return;

    float probability = 0.004 + 0.004 * (
        float(IsDissolvableByAcid(upLeft, 0)) +
        float(IsDissolvableByAcid(upRight, 0)) +
        float(IsDissolvableByAcid(downLeft, 0)) +
        float(IsDissolvableByAcid(downRight, 0))
    );

    bool neutralized = NeutralizeAcid(upLeft, probability * 0.25, random);
    neutralized = neutralized || NeutralizeAcid(upRight, probability * 0.5, random);
    neutralized = neutralized || NeutralizeAcid(downLeft, probability * 0.75, random);
    neutralized = neutralized || NeutralizeAcid(downRight, probability, random);
}

void MoveAcidDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    if (upLeft.type == ACID)
    {
        if (IsMovableByAcid(downLeft, random) && random < 0.9)
        {
            leftFell = true;
            SwapParticles(upLeft, downLeft);
        }
        else if (IsMovableByAcid(upRight, random) && IsMovableByAcid(downRight, random))
        {
            SwapParticles(upLeft, downRight);
        }
    }

    if (upRight.type == ACID)
    {
        if (IsMovableByAcid(downRight, random) && random < 0.9)
        {
            rightFell = true;
            SwapParticles(upRight, downRight);
        }
        else if (IsMovableByAcid(upLeft, random) && IsMovableByAcid(downLeft, random))
        {
            SwapParticles(upRight, downLeft);
        }
    }
}

void MoveAcidLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, bool leftFell, bool rightFell)
{
    if (random < 0.8 &&
        ((upLeft.type == ACID && IsMovableByAcid(upRight, random) && !leftFell) ||
        (upRight.type == ACID && IsMovableByAcid(upLeft, random) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (random < 0.5 &&
        ((downLeft.type == ACID && IsMovableByAcid(downRight, random) && !leftFell) ||
        (downRight.type == ACID && IsMovableByAcid(downLeft, random) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdateAcid(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissolveParticlesByAcid(upLeft, upRight, downLeft, downRight, randomA, randomB);
    NeutralizeAcid(upLeft, upRight, downLeft, downRight, randomC);

    bool leftFell = false;
    bool rightFell = false;
    MoveAcidDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveAcidLaterally(upLeft, upRight, downLeft, downRight, randomC, leftFell, rightFell);
}
