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

void DissipateSteam(inout Particle upLeft, inout Particle upRight, vec4 random)
{
    if (random.z < 0.05)
    {
        DissipateSteam(upLeft, random.y);
        DissipateSteam(upRight, random.y);
    }
}

void UpdateSteam(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    DissipateSteam(upLeft, upRight, random);
    MoveGas(STEAM, 5.2, upLeft, upRight, downLeft, downRight, random);
}
