bool IsMovableByWater(Particle particle)
{
    switch (particle.type)
    {
        case VOID: return true;
        case SMOKE: return true;
        default: return false;
    }
}

void MoveWaterDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    if (upLeft.type == WATER)
    {
        if (IsMovableByWater(downLeft) && random < 0.9)
        {
            leftFell = true;
            SwapParticles(upLeft, downLeft);
        }
        else if (IsMovableByWater(upRight) && IsMovableByWater(downRight))
        {
            SwapParticles(upLeft, downRight);
        }
    }

    if (upRight.type == WATER)
    {
        if (IsMovableByWater(downRight) && random < 0.9)
        {
            rightFell = true;
            SwapParticles(upRight, downRight);
        }
        else if (IsMovableByWater(upLeft) && IsMovableByWater(downLeft))
        {
            SwapParticles(upRight, downLeft);
        }
    }
}

void MoveWaterLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, bool leftFell, bool rightFell)
{
    if (random < 0.8 &&
        ((upLeft.type == WATER && IsMovableByWater(upRight) && !leftFell) ||
        (upRight.type == WATER && IsMovableByWater(upLeft) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (random < 0.5 &&
        ((downLeft.type == WATER && IsMovableByWater(downRight) && !leftFell) ||
        (downRight.type == WATER && IsMovableByWater(downLeft) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdateWater(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB)
{
    bool leftFell = false;
    bool rightFell = false;
    MoveWaterDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveWaterLaterally(upLeft, upRight, downLeft, downRight, randomB, leftFell, rightFell);
}
