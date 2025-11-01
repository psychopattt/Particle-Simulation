bool IsMovableBySmoke(Particle particle)
{
    return particle.type == VOID;
}

void DissipateSmoke(inout Particle particle)
{
    if (particle.type == SMOKE)
        particle.shade < -0.6 ? particle.type = VOID : particle.shade -= 0.01;
}

void DissipateSmoke(inout Particle upLeft, inout Particle upRight, float random)
{
    if (random < 0.06)
    {
        DissipateSmoke(upLeft);
        DissipateSmoke(upRight);
    }
}

void MoveSmokeLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (random < 0.25)
    {
        if ((upLeft.type == SMOKE && IsMovableBySmoke(upRight)) ||
            (upRight.type == SMOKE && IsMovableBySmoke(upLeft)))
        {
            SwapParticles(upLeft, upRight);
        }

        if ((downLeft.type == SMOKE && IsMovableBySmoke(downRight)) ||
            (downRight.type == SMOKE && IsMovableBySmoke(downLeft)))
        {
            SwapParticles(downLeft, downRight);
        }
    }
}

void MoveLeftSmokeUp(inout Particle upLeft, inout Particle upRight, inout Particle downLeft)
{
    if (downLeft.type == SMOKE)
    {
        if (IsMovableBySmoke(upLeft))
            SwapParticles(downLeft, upLeft);
        else if (IsMovableBySmoke(upRight))
            SwapParticles(downLeft, upRight);
    }
}

void MoveRightSmokeUp(inout Particle upLeft, inout Particle upRight, inout Particle downRight)
{
    if (downRight.type == SMOKE)
    {
        if (IsMovableBySmoke(upRight))
            SwapParticles(downRight, upRight);
        else if (IsMovableBySmoke(upLeft))
            SwapParticles(downRight, upLeft);
    }
}

void MoveSmokeUp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (random < 0.2)
    {
        MoveLeftSmokeUp(upLeft, upRight, downLeft);
        MoveRightSmokeUp(upLeft, upRight, downRight);
    }
    else if (random < 0.4)
    {
        MoveRightSmokeUp(upLeft, upRight, downRight);
        MoveLeftSmokeUp(upLeft, upRight, downLeft);
    }
}

void UpdateSmoke(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissipateSmoke(upLeft, upRight, randomA);
    MoveSmokeLaterally(upLeft, upRight, downLeft, downRight, randomB);
    MoveSmokeUp(upLeft, upRight, downLeft, downRight, randomC);
}
