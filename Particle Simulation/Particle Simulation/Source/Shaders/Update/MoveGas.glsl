void MoveGasLaterally(int type, bool light, inout Particle left,
    inout Particle right, float random)
{
    Particle originA = light ? right : left;
    Particle originB = light ? left : right;

    if ((originA.type == type && CanMoveParticle(left, right, random)) ||
        (originB.type == type && CanMoveParticle(right, left, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveGasLaterally(int type, bool light, inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveGasLaterally(type, light, upLeft, upRight, random);
    MoveGasLaterally(type, light, downLeft, downRight, random);
}

void MoveGasUp(int type, inout Particle moving,
    inout Particle top, inout Particle diagonal, float random)
{
    if (moving.type == type)
    {
        if (CanMoveParticle(top, moving, random))
            SwapParticles(moving, top);
        else if (CanMoveParticle(diagonal, moving, random))
            SwapParticles(moving, diagonal);
    }
}

void MoveGasUp(int type, inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (randomB < 0.5)
    {
        MoveGasUp(type, downLeft, upLeft, upRight, randomA);
        MoveGasUp(type, downRight, upRight, upLeft, randomA);
    }
    else
    {
        MoveGasUp(type, downRight, upRight, upLeft, randomA);
        MoveGasUp(type, downLeft, upLeft, upRight, randomA);
    }
}

void MoveGasDown(int type, inout Particle moving,
    inout Particle bottom, inout Particle diagonal, float random)
{
    if (moving.type == type)
    {
        if (CanMoveParticle(moving, bottom, random))
            SwapParticles(moving, bottom);
        else if (CanMoveParticle(moving, diagonal, random))
            SwapParticles(moving, diagonal);
    }
}

void MoveGasDown(int type, inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (randomB < 0.5)
    {
        MoveGasDown(type, upLeft, downLeft, downRight, randomA);
        MoveGasDown(type, upRight, downRight, downLeft, randomA);
    }
    else
    {
        MoveGasDown(type, upRight, downRight, downLeft, randomA);
        MoveGasDown(type, upLeft, downLeft, downRight, randomA);
    }
}

void MoveGas(int type, float lateralMultiplier, inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    float lateralRandom = randomA * lateralMultiplier;
    bool light = GetParticleDensity(type) < GetParticleDensity(AIR);
    MoveGasLaterally(type, light, upLeft, upRight, downLeft, downRight, lateralRandom);

    if (light) {
        MoveGasUp(type, upLeft, upRight, downLeft, downRight, randomA, randomB);
    } else {
        MoveGasDown(type, upLeft, upRight, downLeft, downRight, randomA, randomB);
    }
}
