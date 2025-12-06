bool CanVaporizeWater(Particle particle, float random)
{
    switch (particle.type)
    {
        case FIRE: return random < 0.014;
        case LAVA: return random < 0.07;
        default: return false;
    }
}

bool IsMovableByWater(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return true;
        case SMOKE: return true;
        case KEROSENE: return random < 0.45;
        case STEAM: return true;
        case METHANE: return true;
        case AMMONIA: return true;
        default: return false;
    }
}

void VaporizeWater(inout Particle particle)
{
    if (particle.type == WATER)
        particle.type = STEAM;
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

void MoveWaterDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    if (upLeft.type == WATER)
    {
        if (IsMovableByWater(downLeft, random) && random < 0.9)
        {
            leftFell = true;
            SwapParticles(upLeft, downLeft);
        }
        else if (IsMovableByWater(upRight, random) && IsMovableByWater(downRight, random))
        {
            SwapParticles(upLeft, downRight);
        }
    }

    if (upRight.type == WATER)
    {
        if (IsMovableByWater(downRight, random) && random < 0.9)
        {
            rightFell = true;
            SwapParticles(upRight, downRight);
        }
        else if (IsMovableByWater(upLeft, random) && IsMovableByWater(downLeft, random))
        {
            SwapParticles(upRight, downLeft);
        }
    }
}

void MoveWaterLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, bool leftFell, bool rightFell)
{
    if (random < 0.8 &&
        ((upLeft.type == WATER && IsMovableByWater(upRight, random) && !leftFell) ||
        (upRight.type == WATER && IsMovableByWater(upLeft, random) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (random < 0.5 &&
        ((downLeft.type == WATER && IsMovableByWater(downRight, random) && !leftFell) ||
        (downRight.type == WATER && IsMovableByWater(downLeft, random) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdateWater(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB)
{
    VaporizeWater(upLeft, upRight, downLeft, downRight, randomA, randomB);

    bool leftFell = false;
    bool rightFell = false;
    MoveWaterDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveWaterLaterally(upLeft, upRight, downLeft, downRight, randomB, leftFell, rightFell);
}
