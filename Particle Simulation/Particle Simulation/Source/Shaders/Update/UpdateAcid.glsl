bool IsDissolvableByAcid(Particle particle, float random)
{
    switch (particle.type)
    {
        case SAND: return random < 0.002;
        case WATER: return random < 0.017;
        case WOOD: return random < 0.034;
        case ROCK: return random < 0.005;
        case PETROL: return random < 0.012;
        case STEAM: return random < 0.0187;
        case SEAWATER: return random < 0.0154;
        case LAVA: return random < 0.007;
        case ICE: return random < 0.0124;
        case SALT: return random < 0.008;
        case SAWDUST: return random < 0.074;
        case VINE: return random < 0.059;
        case RUST: return random < 0.01;
        case IRON: return random < 0.006;
        case METHANE: return random < 0.002;
        case AMMONIA: return random < 0.008;
        case WAX: return random < 0.05;
        case MERCURY: return random < 0.006;
        default: return false;
    }
}

void DissolveParticleByAcid(inout Particle particle, float random)
{
    if (IsDissolvableByAcid(particle, random))
    {
        int newType = IsDissolvableByAcid(particle, random * 8) ? SMOKE : AIR;
        particle = CreateParticle(newType, particle.shade);
    }
}

void DissolveParticlesByAcid(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    if (upRight.type == ACID || downLeft.type == ACID)
    {
        if (random.x < 0.5)
            DissolveParticleByAcid(upLeft, random.y);
        else
            DissolveParticleByAcid(downRight, random.y);
    }

    if (upLeft.type == ACID || downRight.type == ACID)
    {
        if (random.y < 0.5)
            DissolveParticleByAcid(upRight, random.x);
        else
            DissolveParticleByAcid(downLeft, random.x);
    }
}

bool NeutralizeAcid(inout Particle particle, float probability, float random)
{
    bool neutralized = particle.type == ACID && random < probability;

    if (neutralized)
    {
        int newType = particle.shade > 0.44 ? SMOKE : AIR;
        particle = CreateParticle(newType, particle.shade);
    }

    return neutralized;
}

void NeutralizeAcid(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    bool allAcid = upLeft.type == ACID && upRight.type == ACID &&
        downLeft.type == ACID && downRight.type == ACID;

    if (allAcid)
        return;

    float probability = 0.004 + 0.004 * (
        float(IsDissolvableByAcid(upLeft, 0)) +
        float(IsDissolvableByAcid(upRight, 0)) +
        float(IsDissolvableByAcid(downLeft, 0)) +
        float(IsDissolvableByAcid(downRight, 0))
    );

    bool neutralized = NeutralizeAcid(upLeft, probability * 0.25, random);
    neutralized = neutralized || NeutralizeAcid(upRight, probability * 0.5, random);
    neutralized = neutralized || NeutralizeAcid(downLeft, probability * 0.75, random);
    neutralized = neutralized || NeutralizeAcid(downRight, probability, random);
}

void UpdateAcid(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    DissolveParticlesByAcid(upLeft, upRight, downLeft, downRight, random);
    NeutralizeAcid(upLeft, upRight, downLeft, downRight, random.z);
    MoveLiquid(ACID, upLeft, upRight, downLeft, downRight, random);
}
