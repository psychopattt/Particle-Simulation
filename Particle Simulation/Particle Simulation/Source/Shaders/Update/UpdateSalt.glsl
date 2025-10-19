bool IsMovableBySalt(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.9;
        case WATER: return random < 0.39;
        case SMOKE: return random < 0.86;
        case KEROSENE: return random < 0.47;
        case STEAM: return random < 0.9;
        case SEAWATER: return random < 0.38;
        case LAVA: return random < 0.125;
        default: return false;
    }
}

void DissolveSalt(inout Particle solvent, inout Particle solute1,
    inout Particle solute2, float random)
{
    if (solvent.type == WATER && random < 0.04)
    {
        solvent.type = SEAWATER;
        solute1.type == SALT ? solute1.type = VOID : solute2.type = VOID;
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

void MoveSalt(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (upLeft.type == SALT)
    {
        if (IsMovableBySalt(downLeft, random))
            SwapParticles(upLeft, downLeft);
        else if (IsMovableBySalt(upRight, random) && IsMovableBySalt(downRight, random))
            SwapParticles(upLeft, downRight);
    }

    if (upRight.type == SALT)
    {
        if (IsMovableBySalt(downRight, random))
            SwapParticles(upRight, downRight);
        else if (IsMovableBySalt(upLeft, random) && IsMovableBySalt(downLeft, random))
            SwapParticles(upRight, downLeft);
    }
}

void UpdateSalt(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissolveSalt(upLeft, upRight, downLeft, downRight, randomA, randomB);
    MoveSalt(upLeft, upRight, downLeft, downRight, randomC);
}
