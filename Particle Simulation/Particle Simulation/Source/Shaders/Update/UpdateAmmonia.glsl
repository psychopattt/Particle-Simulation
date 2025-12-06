bool IsMovableByAmmonia(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.58;
        case SMOKE: return random < 0.23;
        default: return false;
    }
}

void MoveAmmoniaLaterally(inout Particle left, inout Particle right, float random)
{
    if ((left.type == AMMONIA && IsMovableByAmmonia(right, random)) ||
        (right.type == AMMONIA && IsMovableByAmmonia(left, random)))
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
        if (IsMovableByAmmonia(top, random))
            SwapParticles(moving, top);
        else if (IsMovableByAmmonia(diagonal, random))
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
