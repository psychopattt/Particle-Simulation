bool IsMovableByStone(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.9;
        case WATER: return random < 0.63;
        case SMOKE: return random < 0.9;
        case KEROSENE: return random < 0.72;
        case STEAM: return random < 0.9;
        case SEAWATER: return random < 0.63;
        case LAVA: return random < 0.21;
        case ACID: return random < 0.35;
        case METHANE: return random < 0.9;
        case AMMONIA: return random < 0.9;
        default: return false;
    }
}

void UpdateStoneSide(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random)
{
    float diagonalRandom = random * 10;

    if (moving.type == STONE)
    {
        if (IsMovableByStone(bottom, random))
        {
            SwapParticles(moving, bottom);
        }
        else if (IsMovableByStone(side, diagonalRandom) &&
            IsMovableByStone(diagonal, diagonalRandom))
        {
            SwapParticles(moving, diagonal);
        }
    }
}

void UpdateStone(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    UpdateStoneSide(upLeft, upRight, downLeft, downRight, random);
    UpdateStoneSide(upRight, upLeft, downRight, downLeft, random);
}
