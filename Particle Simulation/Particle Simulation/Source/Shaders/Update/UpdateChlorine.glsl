bool CanIgniteChlorine(Particle particle, float random)
{
    switch (particle.type)
    {
        case IRON: return random < 0.03;
        case AMMONIA: return random < 0.004;
        default: return false;
    }
}

void IgniteChlorine(inout Particle particle)
{
    if (particle.type == CHLORINE)
        particle = CreateParticle(FIRE, particle.shade);
}

void IgniteChlorine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (CanIgniteChlorine(upLeft, random) || CanIgniteChlorine(upRight, random) ||
        CanIgniteChlorine(downLeft, random) || CanIgniteChlorine(downRight, random))
    {
        IgniteChlorine(upLeft);
        IgniteChlorine(downRight);
    }
}

void DissolveChlorine(inout Particle solvent, inout Particle solute1,
    inout Particle solute2, float random)
{
    if (solvent.type == WATER && random < 0.05)
    {
        Particle air = CreateParticle(VOID, 0);
        solute1.type == CHLORINE ? solute1 = air : solute2 = air;
        solvent = CreateParticle(SEAWATER, solvent.shade);
    }
}

void DissolveChlorine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (upRight.type == CHLORINE || downLeft.type == CHLORINE)
    {
        if (randomA < 0.5)
            DissolveChlorine(upLeft, downLeft, upRight, randomB);
        else
            DissolveChlorine(downRight, upRight, downLeft, randomB);
    }

    if (upLeft.type == CHLORINE || downRight.type == CHLORINE)
    {
        if (randomB < 0.5)
            DissolveChlorine(upRight, downRight, upLeft, randomA);
        else
            DissolveChlorine(downLeft, upLeft, downRight, randomA);
    }
}

void MoveChlorineLaterally(inout Particle left, inout Particle right, float random)
{
    if ((left.type == CHLORINE && CanMoveParticle(left, right, random)) ||
        (right.type == CHLORINE && CanMoveParticle(right, left, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveChlorineLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveChlorineLaterally(upLeft, upRight, random);
    MoveChlorineLaterally(downLeft, downRight, random);
}

void MoveChlorineDown(inout Particle moving, inout Particle bottom,
    inout Particle diagonal, float random)
{
    if (moving.type == CHLORINE)
    {
        if (CanMoveParticle(moving, bottom, random))
            SwapParticles(moving, bottom);
        else if (CanMoveParticle(moving, diagonal, random))
            SwapParticles(moving, diagonal);
    }
}

void MoveChlorineDown(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (randomB < 0.5)
    {
        MoveChlorineDown(upLeft, downLeft, downRight, randomA);
        MoveChlorineDown(upRight, downRight, downLeft, randomA);
    }
    else
    {
        MoveChlorineDown(upRight, downRight, downLeft, randomA);
        MoveChlorineDown(upLeft, downLeft, downRight, randomA);
    }
}

void UpdateChlorine(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    IgniteChlorine(upLeft, upRight, downLeft, downRight, randomC);
    DissolveChlorine(upLeft, upRight, downLeft, downRight, randomA, randomB);
    MoveChlorineLaterally(upLeft, upRight, downLeft, downRight, randomA * 1.05);
    MoveChlorineDown(upLeft, upRight, downLeft, downRight, randomA, randomB);
}
