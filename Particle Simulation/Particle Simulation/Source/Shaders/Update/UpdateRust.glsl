bool IsMovableByRust(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.9;
        case WATER: return random < 0.72;
        case SMOKE: return random < 0.9;
        case KEROSENE: return random < 0.82;
        case STEAM: return random < 0.9;
        case SEAWATER: return random < 0.72;
        case LAVA: return random < 0.24;
        case ACID: return random < 0.4;
        default: return false;
    }
}

void UpdateRustSide(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random)
{
    if (moving.type == RUST)
    {
        if (IsMovableByRust(bottom, random))
            SwapParticles(moving, bottom);
        else if (IsMovableByRust(side, random) && IsMovableByRust(diagonal, random))
            SwapParticles(moving, diagonal);
    }
}

void UpdateRust(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    UpdateRustSide(upLeft, upRight, downLeft, downRight, random);
    UpdateRustSide(upRight, upLeft, downRight, downLeft, random);
}
