bool IsMovableBySand(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.9;
        case WATER: return random < 0.5;
        case SMOKE: return random < 0.88;
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
