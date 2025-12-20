void DissolveSalt(inout Particle solvent, inout Particle solute1,
    inout Particle solute2, float random)
{
    if (solvent.type == WATER && random < 0.04)
    {
        Particle air = CreateParticle(VOID, 0);
        solute1.type == SALT ? solute1 = air : solute2 = air;
        solvent = CreateParticle(SEAWATER, solvent.shade);
    }
}

void DissolveSalt(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (upRight.type == SALT || downLeft.type == SALT)
    {
        if (randomA < 0.5)
            DissolveSalt(upLeft, downLeft, upRight, randomB);
        else
            DissolveSalt(downRight, upRight, downLeft, randomB);
    }

    if (upLeft.type == SALT || downRight.type == SALT)
    {
        if (randomB < 0.5)
            DissolveSalt(upRight, downRight, upLeft, randomA);
        else
            DissolveSalt(downLeft, upLeft, downRight, randomA);
    }
}

void MoveSaltSide(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random)
{
    if (moving.type == SALT)
    {
        if (CanMoveParticle(moving, bottom, random))
        {
            SwapParticles(moving, bottom);
        }
        else if (CanMoveParticle(moving, side, random) &&
            CanMoveParticle(moving, diagonal, random))
        {
            SwapParticles(moving, diagonal);
        }
    }
}

void MoveSalt(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveSaltSide(upLeft, upRight, downLeft, downRight, random);
    MoveSaltSide(upRight, upLeft, downRight, downLeft, random);
}

void UpdateSalt(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissolveSalt(upLeft, upRight, downLeft, downRight, randomA, randomB);
    MoveSalt(upLeft, upRight, downLeft, downRight, randomC);
}
