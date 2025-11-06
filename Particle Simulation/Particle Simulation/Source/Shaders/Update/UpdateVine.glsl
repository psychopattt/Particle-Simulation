bool CanKillVine(Particle particle, float random)
{
    switch (particle.type)
    {
        case SMOKE: return random < 0.0015;
        case KEROSENE: return random < 0.025;
        case SEAWATER: return random < 0.011;
        case SALT: return random < 0.015;
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
        case STONE: return random < 0.12;
        case ICE: return random < 0.04;
        case SAWDUST: return random < 0.13;
        case RUST: return random < 0.12;
        default: return false;
    }
}

bool KillVine(inout Particle particle, float probability, float random)
{
    bool dead = particle.type == VINE && random < probability;

    if (dead)
        particle.type = VOID;

    return dead;
}

void KillVine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    float probability = 0.33 * (
        float(CanKillVine(upLeft, randomB)) +
        float(CanKillVine(upRight, randomB)) +
        float(CanKillVine(downLeft, randomB)) +
        float(CanKillVine(downRight, randomB))
    );

    bool dead = KillVine(upLeft, probability * 0.25, randomA);
    dead = dead || KillVine(upRight, probability * 0.5, randomA);
    dead = dead || KillVine(downLeft, probability * 0.75, randomA);
    dead = dead || KillVine(downRight, probability, randomA);
}

void GrowVineSide(Particle up, inout Particle down)
{
    if (up.type == VINE && up.shade < -0.2 && down.type == VOID)
        down = Particle(VINE, up.shade + 0.005);
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
    bool typesValid = origin.type == VINE && target.type == VOID;
    bool supported = CanSupportVine(supportA, random) ||
        CanSupportVine(supportB, random);

    if (typesValid && supported)
        target = Particle(VINE, HashVec2(vec2(random, origin.shade)) - 0.5);
}

void SpreadVine(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomB, float randomC)
{
    if (randomB < 0.5)
    {
        SpreadVinePattern(upLeft, upRight, downLeft, downRight, randomC);
        SpreadVinePattern(upLeft, downLeft, upRight, downRight, randomC);

        SpreadVinePattern(downRight, downLeft, upLeft, upRight, randomC);
        SpreadVinePattern(downRight, upRight, upLeft, downLeft, randomC);
    }
    else
    {
        SpreadVinePattern(upRight, upLeft, downLeft, downRight, randomC);
        SpreadVinePattern(upRight, downRight, upLeft, downLeft, randomC);

        SpreadVinePattern(downLeft, downRight, upLeft, upRight, randomC);
        SpreadVinePattern(downLeft, upLeft, upRight, downRight, randomC);
    }
}

void UpdateVine(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    KillVine(upLeft, upRight, downLeft, downRight, randomA, randomB);
    GrowVine(upLeft, upRight, downLeft, downRight, randomA);
    SpreadVine(upLeft, upRight, downLeft, downRight, randomB, randomC);
}
