bool CanMoveGasParticle(Particle origin, Particle target, float random)
{
    float densityDelta = target.density - origin.density;
    float moveProbability = min(0.9, densityDelta / target.density);
    bool mixable = origin.phase == PHASE_GAS && target.phase == PHASE_GAS;

    return mixable && random < moveProbability;
}

void MoveGasLaterally(int type, inout Particle left, inout Particle right, float random)
{
    if ((left.type == type && CanMoveGasParticle(left, right, random)) ||
        (right.type == type && CanMoveGasParticle(right, left, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveGasLaterally(int type, inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveGasLaterally(type, upLeft, upRight, random);
    MoveGasLaterally(type, downLeft, downRight, random);
}

void MoveGasUp(int type, inout Particle moving,
    inout Particle top, inout Particle diagonal, float random)
{
    if (moving.type == type)
    {
        if (CanMoveGasParticle(moving, top, random))
            SwapParticles(moving, top);
        else if (CanMoveGasParticle(moving, diagonal, random))
            SwapParticles(moving, diagonal);
    }
}

void MoveGasUp(int type, inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    if (random.y < 0.5)
    {
        MoveGasUp(type, downLeft, upLeft, upRight, random.x);
        MoveGasUp(type, downRight, upRight, upLeft, random.x);
    }
    else
    {
        MoveGasUp(type, downRight, upRight, upLeft, random.x);
        MoveGasUp(type, downLeft, upLeft, upRight, random.x);
    }
}

void MoveGas(int type, float lateralMultiplier, inout Particle upLeft,
    inout Particle upRight, inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float lateralRandom = random.x * lateralMultiplier;
    MoveGasLaterally(type, upLeft, upRight, downLeft, downRight, lateralRandom);
    MoveGasUp(type, upLeft, upRight, downLeft, downRight, random);
}
