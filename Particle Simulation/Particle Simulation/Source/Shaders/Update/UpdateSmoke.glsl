void DissipateSmoke(inout Particle particle)
{
    if (particle.type == SMOKE)
    {
        if (particle.shade < -0.6)
            particle = CreateParticle(AIR, 0);
        else
            particle.shade -= 0.01;
    }
}

void DissipateSmoke(inout Particle upLeft, inout Particle upRight, float random)
{
    if (random < 0.06)
    {
        DissipateSmoke(upLeft);
        DissipateSmoke(upRight);
    }
}

void UpdateSmoke(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    DissipateSmoke(upLeft, upRight, randomC);
    MoveGas(SMOKE, 1.6, upLeft, upRight, downLeft, downRight, randomA, randomB);
}
