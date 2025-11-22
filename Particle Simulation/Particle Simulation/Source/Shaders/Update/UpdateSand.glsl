bool IsMovableBySand(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.9;
        case WATER: return random < 0.4;
        case SMOKE: return random < 0.88;
        case KEROSENE: return random < 0.48;
        case STEAM: return random < 0.9;
        case SEAWATER: return random < 0.39;
        case LAVA: return random < 0.13;
        case ACID: return random < 0.22;
        case METHANE: return random < 0.89;
        default: return false;
    }
}

void UpdateSand(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (upLeft.type == SAND)
    {
        if (IsMovableBySand(downLeft, random))
            SwapParticles(upLeft, downLeft);
        else if (IsMovableBySand(upRight, random) && IsMovableBySand(downRight, random))
            SwapParticles(upLeft, downRight);
    }

    if (upRight.type == SAND)
    {
        if (IsMovableBySand(downRight, random))
            SwapParticles(upRight, downRight);
        else if (IsMovableBySand(upLeft, random) && IsMovableBySand(downLeft, random))
            SwapParticles(upRight, downLeft);
    }
}
