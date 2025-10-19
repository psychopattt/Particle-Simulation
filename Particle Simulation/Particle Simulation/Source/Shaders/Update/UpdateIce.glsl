bool IsFreezableByIce(Particle particle, float random)
{
    return particle.type == WATER && random < 0.05;
}

bool CanMeltIce(Particle particle, float random)
{
    switch (particle.type)
    {
        case FIRE: return random < 0.4;
        case LAVA: return random < 0.3;
        case SALT: return random < 0.01;
        default: return false;
    }
}

void FreezeParticleIntoIce(inout Particle particle, float random)
{
    if (IsFreezableByIce(particle, random))
        particle.type = ICE;
}

void FreezeParticlesIntoIce(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    if (upRight.type == ICE || downLeft.type == ICE)
    {
        if (randomA < 0.5)
            FreezeParticleIntoIce(upLeft, randomB);
        else
            FreezeParticleIntoIce(downRight, randomB);
    }

    if (upLeft.type == ICE || downRight.type == ICE)
    {
        if (randomB < 0.5)
            FreezeParticleIntoIce(upRight, randomA);
        else
            FreezeParticleIntoIce(downLeft, randomA);
    }
}

void MeltIce(inout Particle particle)
{
    if (particle.type == ICE)
        particle.type = WATER;
}

void MeltIce(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomB, float randomC)
{
    float meltProbability = 0.35 * (
        float(CanMeltIce(upLeft, randomB)) +
        float(CanMeltIce(upRight, randomB)) +
        float(CanMeltIce(downLeft, randomB)) +
        float(CanMeltIce(downRight, randomB))
    );

    if (randomC < meltProbability)
    {
        MeltIce(upLeft);
        MeltIce(upRight);
        MeltIce(downLeft);
        MeltIce(downRight);
    }
}

void UpdateIce(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    FreezeParticlesIntoIce(upLeft, upRight, downLeft, downRight, randomA, randomB);
    MeltIce(upLeft, upRight, downLeft, downRight, randomB, randomC);
}
