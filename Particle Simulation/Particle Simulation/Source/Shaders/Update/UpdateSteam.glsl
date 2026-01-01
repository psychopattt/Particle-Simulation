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

void UpdateSteam(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissipateSteam(upLeft, upRight, randomB, randomC);
    MoveGas(STEAM, 5.2, upLeft, upRight, downLeft, downRight, randomA, randomB);
}
