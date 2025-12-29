void MoveMethaneLaterally(inout Particle left, inout Particle right, float random)
{
    if ((left.type == METHANE && CanMoveParticle(right, left, random)) ||
        (right.type == METHANE && CanMoveParticle(left, right, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveMethaneLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveMethaneLaterally(upLeft, upRight, random);
    MoveMethaneLaterally(downLeft, downRight, random);
}

void MoveMethaneUp(inout Particle moving, inout Particle top,
    inout Particle diagonal, float random)
{
    if (moving.type == METHANE)
    {
        if (CanMoveParticle(top, moving, random))
            SwapParticles(moving, top);
        else if (CanMoveParticle(diagonal, moving, random))
            SwapParticles(moving, diagonal);
    }
}

void MoveMethaneUp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (randomB < 0.5)
    {
        MoveMethaneUp(downLeft, upLeft, upRight, randomA);
        MoveMethaneUp(downRight, upRight, upLeft, randomA);
    }
    else
    {
        MoveMethaneUp(downRight, upRight, upLeft, randomA);
        MoveMethaneUp(downLeft, upLeft, upRight, randomA);
    }
}

void UpdateMethane(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    MoveMethaneLaterally(upLeft, upRight, downLeft, downRight, randomA * 1.17);
    MoveMethaneUp(upLeft, upRight, downLeft, downRight, randomA, randomB);
}
