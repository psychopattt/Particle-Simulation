void DissolveSalt(inout Particle solvent, inout Particle solute1,
    inout Particle solute2, float random)
{
    if (solvent.type == WATER && random < 0.04)
    {
        Particle air = CreateParticle(AIR, 0);
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

void UpdateSalt(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissolveSalt(upLeft, upRight, downLeft, downRight, randomA, randomB);
    MoveSolid(SALT, 1, upLeft, upRight, downLeft, downRight, randomC);
}
