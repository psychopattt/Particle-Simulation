bool IsMovableBySawdust(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.79;
        case WATER: return random < 0.35;
        case SMOKE: return random < 0.77;
        case FIRE: return random < 0.62;
        case KEROSENE: return random < 0.42;
        case STEAM: return random < 0.9;
        case SEAWATER: return random < 0.34;
        case LAVA: return random < 0.11;
        case ACID: return random < 0.19;
        default: return false;
    }
}

void UpdateSawdust(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (upLeft.type == SAWDUST)
    {
        if (IsMovableBySawdust(downLeft, random))
            SwapParticles(upLeft, downLeft);
        else if (IsMovableBySawdust(upRight, random) && IsMovableBySawdust(downRight, random))
            SwapParticles(upLeft, downRight);
    }

    if (upRight.type == SAWDUST)
    {
        if (IsMovableBySawdust(downRight, random))
            SwapParticles(upRight, downRight);
        else if (IsMovableBySawdust(upLeft, random) && IsMovableBySawdust(downLeft, random))
            SwapParticles(upRight, downLeft);
    }
}
