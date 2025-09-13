bool IsMovableByKerosene(Particle particle)
{
    switch (particle.type)
    {
        case VOID: return true;
        case SMOKE: return true;
        default: return false;
    }
}

void MoveKeroseneDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    if (upLeft.type == KEROSENE)
    {
        if (IsMovableByKerosene(downLeft) && random < 0.9)
        {
            leftFell = true;
            SwapParticles(upLeft, downLeft);
        }
        else if (IsMovableByKerosene(upRight) && IsMovableByKerosene(downRight))
        {
            SwapParticles(upLeft, downRight);
        }
    }

    if (upRight.type == KEROSENE)
    {
        if (IsMovableByKerosene(downRight) && random < 0.9)
        {
            rightFell = true;
            SwapParticles(upRight, downRight);
        }
        else if (IsMovableByKerosene(upLeft) && IsMovableByKerosene(downLeft))
        {
            SwapParticles(upRight, downLeft);
        }
    }
}

void MoveKeroseneLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, bool leftFell, bool rightFell)
{
    if (random < 0.8 &&
        ((upLeft.type == KEROSENE && IsMovableByKerosene(upRight) && !leftFell) ||
        (upRight.type == KEROSENE && IsMovableByKerosene(upLeft) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (random < 0.5 &&
        ((downLeft.type == KEROSENE && IsMovableByKerosene(downRight) && !leftFell) ||
        (downRight.type == KEROSENE && IsMovableByKerosene(downLeft) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdateKerosene(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB)
{
    bool leftFell = false;
    bool rightFell = false;
    MoveKeroseneDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveKeroseneLaterally(upLeft, upRight, downLeft, downRight, randomB, leftFell, rightFell);
}
