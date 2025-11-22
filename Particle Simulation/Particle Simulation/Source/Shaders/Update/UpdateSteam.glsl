bool IsMovableBySteam(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return true;
        case SMOKE: return random < 0.4;
        case METHANE: return random < 0.32;
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

void DissipateSteam(inout Particle upLeft, inout Particle upRight, float randomA, float randomB)
{
    if (randomA < 0.05)
    {
        DissipateSteam(upLeft, randomB);
        DissipateSteam(upRight, randomB);
    }
}

void MoveSteamLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (randomB < 0.14)
    {
        if ((upLeft.type == STEAM && IsMovableBySteam(upRight, randomA)) ||
            (upRight.type == STEAM && IsMovableBySteam(upLeft, randomA)))
        {
            SwapParticles(upLeft, upRight);
        }

        if ((downLeft.type == STEAM && IsMovableBySteam(downRight, randomA)) ||
            (downRight.type == STEAM && IsMovableBySteam(downLeft, randomA)))
        {
            SwapParticles(downLeft, downRight);
        }
    }
}

void MoveLeftSteamUp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, float random)
{
    if (downLeft.type == STEAM)
    {
        if (IsMovableBySteam(upLeft, random))
            SwapParticles(downLeft, upLeft);
        else if (IsMovableBySteam(upRight, random))
            SwapParticles(downLeft, upRight);
    }
}

void MoveRightSteamUp(inout Particle upLeft, inout Particle upRight,
    inout Particle downRight, float random)
{
    if (downRight.type == STEAM)
    {
        if (IsMovableBySteam(upRight, random))
            SwapParticles(downRight, upRight);
        else if (IsMovableBySteam(upLeft, random))
            SwapParticles(downRight, upLeft);
    }
}

void MoveSteamUp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomC)
{
    if (randomC < 0.37)
    {
        MoveLeftSteamUp(upLeft, upRight, downLeft, randomA);
        MoveRightSteamUp(upLeft, upRight, downRight, randomA);
    }
    else if (randomC < 0.74)
    {
        MoveRightSteamUp(upLeft, upRight, downRight, randomA);
        MoveLeftSteamUp(upLeft, upRight, downLeft, randomA);
    }
}

void UpdateSteam(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissipateSteam(upLeft, upRight, randomA, randomB);
    MoveSteamLaterally(upLeft, upRight, downLeft, downRight, randomA, randomB);
    MoveSteamUp(upLeft, upRight, downLeft, downRight, randomA, randomC);
}
