bool CanIgniteChlorine(Particle particle, float random)
{
    switch (particle.type)
    {
        case IRON: return random < 0.03;
        case AMMONIA: return random < 0.004;
        default: return false;
    }
}

void IgniteChlorine(inout Particle particle)
{
    if (particle.type == CHLORINE)
        particle = CreateParticle(FIRE, particle.shade);
}

void IgniteChlorine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (CanIgniteChlorine(upLeft, random) || CanIgniteChlorine(upRight, random) ||
        CanIgniteChlorine(downLeft, random) || CanIgniteChlorine(downRight, random))
    {
        IgniteChlorine(upLeft);
        IgniteChlorine(downRight);
    }
}

void DissolveChlorine(inout Particle solvent, inout Particle solute1,
    inout Particle solute2, float random)
{
    if (solvent.type == WATER && random < 0.05)
    {
        Particle air = CreateParticle(AIR, 0);
        solute1.type == CHLORINE ? solute1 = air : solute2 = air;
        solvent = CreateParticle(SEAWATER, solvent.shade);
    }
}

void DissolveChlorine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    if (upRight.type == CHLORINE || downLeft.type == CHLORINE)
    {
        if (random.x < 0.5)
            DissolveChlorine(upLeft, downLeft, upRight, random.y);
        else
            DissolveChlorine(downRight, upRight, downLeft, random.y);
    }

    if (upLeft.type == CHLORINE || downRight.type == CHLORINE)
    {
        if (random.y < 0.5)
            DissolveChlorine(upRight, downRight, upLeft, random.x);
        else
            DissolveChlorine(downLeft, upLeft, downRight, random.x);
    }
}

void UpdateChlorine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    IgniteChlorine(upLeft, upRight, downLeft, downRight, random.z);
    DissolveChlorine(upLeft, upRight, downLeft, downRight, random);
    MoveGas(CHLORINE, 1.05, upLeft, upRight, downLeft, downRight, random);
}
