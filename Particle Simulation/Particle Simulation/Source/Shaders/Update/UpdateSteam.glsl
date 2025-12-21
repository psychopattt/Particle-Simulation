void DissipateSteam(inout Particle particle, float random)
{
    if (particle.type == STEAM)
    {
        if (particle.shade < -0.75)
            particle = CreateParticle(random < 0.3 ? WATER : AIR, 0.1);
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
    if ((left.type == STEAM && CanMoveParticle(right, left, random)) ||
        (right.type == STEAM && CanMoveParticle(left, right, random)))
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
        if (CanMoveParticle(top, moving, random))
            SwapParticles(moving, top);
        else if (CanMoveParticle(diagonal, moving, random))
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
