bool CanKillKelp(Particle particle, float random)
{
    switch (particle.type)
    {
        case WATER: return false;
        case FIRE: return random < 0.3;
        case PETROL: return random < 0.03;
        case STEAM: return false;
        case SEAWATER: return false;
        case LAVA: return random < 0.3;
        case ACID: return random < 0.1;
        case AMMONIA: return false;
        case KELP: return false;
        default: return random < 0.011;
    }
}

bool CanSustainKelp(Particle particle, float random)
{
    switch (particle.type)
    {
        case WATER: return random < 0.0097;
        case SEAWATER: return random < 0.01;
        default: return false;
    }
}

bool KillKelp(inout Particle particle, float probability, float random)
{
    bool dead = particle.type == KELP && random < probability;
    particle = dead ? CreateParticle(WATER, particle.shade) : particle;

    return dead;
}

void KillKelp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float probability = 0.33 * (
        float(CanKillKelp(upLeft, random.y)) +
        float(CanKillKelp(upRight, random.y)) +
        float(CanKillKelp(downLeft, random.y)) +
        float(CanKillKelp(downRight, random.y))
    );

    bool dead = KillKelp(upLeft, probability * 0.25, random.x);
    dead = dead || KillKelp(upRight, probability * 0.5, random.x);
    dead = dead || KillKelp(downLeft, probability * 0.75, random.x);
    dead = dead || KillKelp(downRight, probability, random.x);
}

void GrowKelp(inout Particle origin, inout Particle target, float random)
{
    if (CanSustainKelp(target, random))
    {
        target = CreateParticle(KELP, target.shade);
        origin.phase = PHASE_STATIC;
    }
}

void GrowKelp(inout Particle origin, inout Particle horizontal,
    inout Particle vertical, float random)
{
    if (origin.type == KELP && origin.shade < 0.37)
    {
        if (origin.shade < -0.065)
            GrowKelp(origin, horizontal, random);
        else
            GrowKelp(origin, vertical, random);
    }
}

void GrowKelp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    GrowKelp(upLeft, upRight, downLeft, random.x);
    GrowKelp(upRight, upLeft, downRight, random.y);
    GrowKelp(downLeft, downRight, upLeft, random.z);
    GrowKelp(downRight, downLeft, upRight, random.w);
}

void UpdateKelp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    KillKelp(upLeft, upRight, downLeft, downRight, random);
    GrowKelp(upLeft, upRight, downLeft, downRight, random);
    MoveSolid(KELP, 34, upLeft, upRight, downLeft, downRight, random);
}
