bool IsMovableByStone(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.9;
        case WATER: return random < 0.63;
        case SMOKE: return random < 0.9;
        case KEROSENE: return random < 0.72;
        case STEAM: return random < 0.9;
        default: return false;
    }
}

void UpdateStone(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (upLeft.type == STONE)
    {
        if (IsMovableByStone(downLeft, random))
            SwapParticles(upLeft, downLeft);
        else if (IsMovableByStone(upRight, random) && IsMovableByStone(downRight, random))
            SwapParticles(upLeft, downRight);
    }

    if (upRight.type == STONE)
    {
        if (IsMovableByStone(downRight, random))
            SwapParticles(upRight, downRight);
        else if (IsMovableByStone(upLeft, random) && IsMovableByStone(downLeft, random))
            SwapParticles(upRight, downLeft);
    }
}
