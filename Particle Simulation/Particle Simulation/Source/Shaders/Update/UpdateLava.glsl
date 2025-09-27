bool IsMovableByLava(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.9;
        case WATER: return random < 0.21;
        case SMOKE: return random < 0.65;
        case FIRE: return random < 0.6;
        case KEROSENE: return random < 0.24;
        case STEAM: return random < 0.7;
        case SEAWATER: return random < 0.21;
        default: return false;
    }
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
    UpdateLavaShade(upLeft, upRight, downLeft, downRight, randomA);

    bool leftFell = false;
    bool rightFell = false;
    MoveLavaDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveLavaLaterally(upLeft, upRight, downLeft, downRight, randomB, randomC, leftFell, rightFell);
}
