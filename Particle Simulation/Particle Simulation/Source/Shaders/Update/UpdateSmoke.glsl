bool IsMovableBySmoke(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.4;
        default: return false;
    }
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

void MoveSmokeLaterally(inout Particle left, inout Particle right, float random)
{
    if ((left.type == SMOKE && IsMovableBySmoke(right, random)) ||
        (right.type == SMOKE && IsMovableBySmoke(left, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveSmokeLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveSmokeLaterally(upLeft, upRight, random);
    MoveSmokeLaterally(downLeft, downRight, random);
}

void MoveSmokeUp(inout Particle moving, inout Particle top,
    inout Particle diagonal, float random)
{
    if (moving.type == SMOKE)
    {
        if (IsMovableBySmoke(top, random))
            SwapParticles(moving, top);
        else if (IsMovableBySmoke(diagonal, random))
            SwapParticles(moving, diagonal);
    }
}

void MoveSmokeUp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (randomB < 0.5)
    {
        MoveSmokeUp(downLeft, upLeft, upRight, randomA);
        MoveSmokeUp(downRight, upRight, upLeft, randomA);
    }
    else
    {
        MoveSmokeUp(downRight, upRight, upLeft, randomA);
        MoveSmokeUp(downLeft, upLeft, upRight, randomA);
    }
}

void UpdateSmoke(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissipateSmoke(upLeft, upRight, randomC);
    MoveSmokeLaterally(upLeft, upRight, downLeft, downRight, randomA * 1.6);
    MoveSmokeUp(upLeft, upRight, downLeft, downRight, randomA, randomB);
}
