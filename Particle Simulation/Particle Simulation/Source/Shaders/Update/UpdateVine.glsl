bool CanKillVine(Particle particle, float random)
{
    switch (particle.type)
    {
        case SMOKE: return random < 0.0015;
        case PETROL: return random < 0.025;
        case SEAWATER: return random < 0.011;
        case SALT: return random < 0.015;
        case METHANE: return random < 0.0012;
        case CHLORINE: return random < 0.008;
        default: return false;
    }
}

bool CanSupportVine(Particle particle, float random)
{
    switch (particle.type)
    {
        case SAND: return random < 0.12;
        case WATER: return random < 0.18;
        case WALL: return random < 0.12;
        case WOOD: return random < 0.13;
        case ROCK: return random < 0.12;
        case ICE: return random < 0.04;
        case SAWDUST: return random < 0.13;
        case RUST: return random < 0.12;
        case IRON: return random < 0.12;
        case AMMONIA: return random < 0.21;
        case WAX: return random < 0.12;
        default: return false;
    }
}

bool KillVine(inout Particle particle, float probability, float random)
{
    bool dead = particle.type == VINE && random < probability;

    if (dead)
        particle = CreateParticle(AIR, 0);

    return dead;
}

void KillVine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float probability = 0.33 * (
        float(CanKillVine(upLeft, random.y)) +
        float(CanKillVine(upRight, random.y)) +
        float(CanKillVine(downLeft, random.y)) +
        float(CanKillVine(downRight, random.y))
    );

    bool dead = KillVine(upLeft, probability * 0.25, random.x);
    dead = dead || KillVine(upRight, probability * 0.5, random.x);
    dead = dead || KillVine(downLeft, probability * 0.75, random.x);
    dead = dead || KillVine(downRight, probability, random.x);
}

void GrowVineSide(Particle up, inout Particle down)
{
    if (up.type == VINE && up.shade < -0.2 && down.type == AIR)
        down = CreateParticle(VINE, up.shade + 0.005);
}

void GrowVine(Particle upLeft, Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    const float growProbability = 0.016;
    const float sideProbability = growProbability * 0.5;

    if (random < growProbability)
    {
        if (random < sideProbability)
            GrowVineSide(upLeft, downLeft);
        else
            GrowVineSide(upRight, downRight);
    }
}

void SpreadVinePattern(Particle origin, inout Particle target,
    Particle supportA, Particle supportB, float random)
{
    bool typesValid = origin.type == VINE && target.type == AIR;
    bool supported = CanSupportVine(supportA, random) ||
        CanSupportVine(supportB, random);

    if (typesValid && supported)
        target = CreateParticle(VINE, HashVec2(vec2(random, origin.shade)) - 0.5);
}

void SpreadVine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    if (random.y < 0.5)
    {
        SpreadVinePattern(upLeft, upRight, downLeft, downRight, random.z);
        SpreadVinePattern(upLeft, downLeft, upRight, downRight, random.z);

        SpreadVinePattern(downRight, downLeft, upLeft, upRight, random.z);
        SpreadVinePattern(downRight, upRight, upLeft, downLeft, random.z);
    }
    else
    {
        SpreadVinePattern(upRight, upLeft, downLeft, downRight, random.z);
        SpreadVinePattern(upRight, downRight, upLeft, downLeft, random.z);

        SpreadVinePattern(downLeft, downRight, upLeft, upRight, random.z);
        SpreadVinePattern(downLeft, upLeft, upRight, downRight, random.z);
    }
}

void UpdateVine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    KillVine(upLeft, upRight, downLeft, downRight, random);
    GrowVine(upLeft, upRight, downLeft, downRight, random.x);
    SpreadVine(upLeft, upRight, downLeft, downRight, random);
}
