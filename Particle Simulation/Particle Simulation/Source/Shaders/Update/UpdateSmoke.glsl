void DissipateSmoke(inout Particle particle)
{
    if (particle.type == SMOKE)
    {
        if (particle.shade < -0.6)
            particle = CreateParticle(VOID, 0);
        else
            particle.shade -= 0.01;
    }
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
    if ((left.type == SMOKE && CanMoveParticle(right, left, random)) ||
        (right.type == SMOKE && CanMoveParticle(left, right, random)))
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
        if (CanMoveParticle(top, moving, random))
            SwapParticles(moving, top);
        else if (CanMoveParticle(diagonal, moving, random))
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
