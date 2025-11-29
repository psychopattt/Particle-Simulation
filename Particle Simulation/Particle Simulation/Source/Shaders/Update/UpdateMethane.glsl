bool IsMovableByMethane(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.6;
        case SMOKE: return random < 0.24;
        default: return false;
    }
}

void MoveMethaneLaterally(inout Particle left, inout Particle right, float random)
{
    if ((left.type == METHANE && IsMovableByMethane(right, random)) ||
        (right.type == METHANE && IsMovableByMethane(left, random)))
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
        if (IsMovableByMethane(top, random))
            SwapParticles(moving, top);
        else if (IsMovableByMethane(diagonal, random))
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
