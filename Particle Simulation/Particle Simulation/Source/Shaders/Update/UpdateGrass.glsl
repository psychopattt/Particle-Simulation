bool CanKillGrass(Particle particle, float random)
{
    switch (particle.type)
    {
        case SMOKE: return random < 0.002;
        case PETROL: return random < 0.033;
        case SEAWATER: return random < 0.015;
        case SALT: return random < 0.02;
        case METHANE: return random < 0.0016;
        case CHLORINE: return random < 0.011;
        default: return false;
    }
}

bool CanSupportGrass(Particle particle, float random)
{
    switch (particle.type)
    {
        case SAND: return random < 0.044;
        case WALL: return random < 0.053;
        case WOOD: return random < 0.057;
        case ROCK: return random < 0.055;
        case SAWDUST: return random < 0.059;
        case VINE: return random < 0.057;
        case RUST: return random < 0.046;
        case CEMENT: return random < 0.053;
        case FOAM: return random < 0.048;
        case BRICK: return random < 0.055;
        default: return false;
    }
}

bool KillGrass(inout Particle particle, float probability, float random)
{
    bool dead = particle.type == GRASS && random < probability;
    particle = dead ? CreateParticle(AIR, 0) : particle;

    return dead;
}

void KillGrass(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float probability = 0.33 * (
        float(CanKillGrass(upLeft, random.y)) +
        float(CanKillGrass(upRight, random.y)) +
        float(CanKillGrass(downLeft, random.y)) +
        float(CanKillGrass(downRight, random.y))
    );

    bool dead = KillGrass(upLeft, probability * 0.25, random.x);
    dead = dead || KillGrass(upRight, probability * 0.5, random.x);
    dead = dead || KillGrass(downLeft, probability * 0.75, random.x);
    dead = dead || KillGrass(downRight, probability, random.x);
}

void SpreadGrass(inout Particle origin, inout Particle target,
    Particle support, vec4 random)
{
    if (origin.type == GRASS && origin.shade < 16)
    {
        origin.shade += 0.0037;

        if (target.type == AIR && CanSupportGrass(support, random.x))
        {
            float shade = GenerateShade(origin.shade, random.y);
            origin.shade = min(16.0037, origin.shade + shade + 1);
            target = CreateParticle(GRASS, shade);
        }
    }
}

void SpreadGrass(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    SpreadGrass(upLeft, upRight, downRight, random);
    SpreadGrass(upRight, upLeft, downLeft, random);

    if (upLeft.type == AIR)
        SpreadGrass(downLeft, upRight, downRight, random);

    if (upRight.type == AIR)
        SpreadGrass(downRight, upLeft, downLeft, random);
}

void GrowGrass(inout Particle origin, inout Particle target, float random)
{
    bool typesValid = origin.type == GRASS && target.type == AIR;
    bool growing = origin.shade > 2 && origin.shade < 14;

    if (typesValid && growing && random < 0.003)
        target = CreateParticle(GRASS, ++origin.shade);
}

void GrowGrass(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    GrowGrass(downLeft, upLeft, random);
    GrowGrass(downRight, upRight, random);
}

void UpdateGrass(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    KillGrass(upLeft, upRight, downLeft, downRight, random);
    SpreadGrass(upLeft, upRight, downLeft, downRight, random);
    MoveSolid(GRASS, 1, upLeft, upRight, downLeft, downRight, random);
    GrowGrass(upLeft, upRight, downLeft, downRight, random.z);
}
