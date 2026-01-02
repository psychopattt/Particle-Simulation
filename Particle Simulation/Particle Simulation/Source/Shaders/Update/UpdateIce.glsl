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
        particle = CreateParticle(ICE, particle.shade);
}

void FreezeParticlesIntoIce(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    if (upRight.type == ICE || downLeft.type == ICE)
    {
        if (random.x < 0.5)
            FreezeParticleIntoIce(upLeft, random.y);
        else
            FreezeParticleIntoIce(downRight, random.y);
    }

    if (upLeft.type == ICE || downRight.type == ICE)
    {
        if (random.y < 0.5)
            FreezeParticleIntoIce(upRight, random.x);
        else
            FreezeParticleIntoIce(downLeft, random.x);
    }
}

void MeltIce(inout Particle particle)
{
    if (particle.type == ICE)
        particle = CreateParticle(WATER, particle.shade);
}

void MeltIce(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float meltProbability = 0.35 * (
        float(CanMeltIce(upLeft, random.y)) +
        float(CanMeltIce(upRight, random.y)) +
        float(CanMeltIce(downLeft, random.y)) +
        float(CanMeltIce(downRight, random.y))
    );

    if (random.z < meltProbability)
    {
        MeltIce(upLeft);
        MeltIce(upRight);
        MeltIce(downLeft);
        MeltIce(downRight);
    }
}

void UpdateIce(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    FreezeParticlesIntoIce(upLeft, upRight, downLeft, downRight, random);
    MeltIce(upLeft, upRight, downLeft, downRight, random);
}
