bool IsMovableBySteam(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return random < 0.74;
        case SMOKE: return random < 0.3;
        case METHANE: return random < 0.18;
        case AMMONIA: return random < 0.19;
        default: return false;
    }
}

void DissipateSteam(inout Particle particle, float random)
{
    if (particle.type == STEAM)
    {
        if (particle.shade < -0.75)
            particle = Particle(random < 0.3 ? WATER : VOID, 0.1);
        else
            particle.shade -= 0.04;
    }
}

void DissipateSteam(inout Particle upLeft, inout Particle upRight, float randomB, float randomC)
{
    if (randomC < 0.05)
    {
        DissipateSteam(upLeft, randomB);
        DissipateSteam(upRight, randomB);
    }
}

void MoveSteamLaterally(inout Particle left, inout Particle right, float random)
{
    if ((left.type == STEAM && IsMovableBySteam(right, random)) ||
        (right.type == STEAM && IsMovableBySteam(left, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveSteamLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveSteamLaterally(upLeft, upRight, random);
    MoveSteamLaterally(downLeft, downRight, random);
}

void MoveSteamUp(inout Particle moving, inout Particle top,
    inout Particle diagonal, float random)
{
    if (moving.type == STEAM)
    {
        if (IsMovableBySteam(top, random))
            SwapParticles(moving, top);
        else if (IsMovableBySteam(diagonal, random))
            SwapParticles(moving, diagonal);
    }
}

void MoveSteamUp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (randomB < 0.5)
    {
        MoveSteamUp(downLeft, upLeft, upRight, randomA);
        MoveSteamUp(downRight, upRight, upLeft, randomA);
    }
    else
    {
        MoveSteamUp(downRight, upRight, upLeft, randomA);
        MoveSteamUp(downLeft, upLeft, upRight, randomA);
    }
}

void UpdateSteam(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissipateSteam(upLeft, upRight, randomB, randomC);
    MoveSteamLaterally(upLeft, upRight, downLeft, downRight, randomA * 5.2);
    MoveSteamUp(upLeft, upRight, downLeft, downRight, randomA, randomB);
}
