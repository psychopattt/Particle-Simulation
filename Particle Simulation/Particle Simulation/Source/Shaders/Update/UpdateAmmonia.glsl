void MoveAmmoniaLaterally(inout Particle left, inout Particle right, float random)
{
    if ((left.type == AMMONIA && CanMoveParticle(right, left, random)) ||
        (right.type == AMMONIA && CanMoveParticle(left, right, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveAmmoniaLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveAmmoniaLaterally(upLeft, upRight, random);
    MoveAmmoniaLaterally(downLeft, downRight, random);
}

void MoveAmmoniaUp(inout Particle moving, inout Particle top,
    inout Particle diagonal, float random)
{
    if (moving.type == AMMONIA)
    {
        if (CanMoveParticle(top, moving, random))
            SwapParticles(moving, top);
        else if (CanMoveParticle(diagonal, moving, random))
            SwapParticles(moving, diagonal);
    }
}

void MoveAmmoniaUp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (randomB < 0.5)
    {
        MoveAmmoniaUp(downLeft, upLeft, upRight, randomA);
        MoveAmmoniaUp(downRight, upRight, upLeft, randomA);
    }
    else
    {
        MoveAmmoniaUp(downRight, upRight, upLeft, randomA);
        MoveAmmoniaUp(downLeft, upLeft, upRight, randomA);
    }
}

void UpdateAmmonia(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    MoveAmmoniaLaterally(upLeft, upRight, downLeft, downRight, randomA * 1.12);
    MoveAmmoniaUp(upLeft, upRight, downLeft, downRight, randomA, randomB);
}
