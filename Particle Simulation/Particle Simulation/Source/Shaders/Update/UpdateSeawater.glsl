bool CanVaporizeSeawater(Particle particle, float random)
{
    switch (particle.type)
    {
        case FIRE: return random < 0.0144;
        case LAVA: return random < 0.072;
        default: return false;
    }
}

bool IsMovableBySeawater(Particle particle, float random)
{
    switch (particle.type)
    {
        case VOID: return true;
        case WATER: return random < 0.08;
        case SMOKE: return true;
        case KEROSENE: return random < 0.49;
        case STEAM: return true;
        case METHANE: return true;
        case AMMONIA: return true;
        case CHLORINE: return true;
        default: return false;
    }
}

void VaporizeSeawater(inout Particle particle)
{
    if (particle.type == SEAWATER)
        particle.type = STEAM;
}

void VaporizeSeawater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    float vaporizeProbability = 0.25 * (
        float(CanVaporizeSeawater(upLeft, randomB)) +
        float(CanVaporizeSeawater(upRight, randomB)) +
        float(CanVaporizeSeawater(downLeft, randomB)) +
        float(CanVaporizeSeawater(downRight, randomB))
    );

    if (randomA < vaporizeProbability)
    {
        VaporizeSeawater(upLeft);
        VaporizeSeawater(upRight);
        VaporizeSeawater(downLeft);
        VaporizeSeawater(downRight);
    }
}

void MoveSeawaterDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    if (upLeft.type == SEAWATER)
    {
        if (IsMovableBySeawater(downLeft, random) && random < 0.9)
        {
            leftFell = true;
            SwapParticles(upLeft, downLeft);
        }
        else if (IsMovableBySeawater(upRight, random) && IsMovableBySeawater(downRight, random))
        {
            SwapParticles(upLeft, downRight);
        }
    }

    if (upRight.type == SEAWATER)
    {
        if (IsMovableBySeawater(downRight, random) && random < 0.9)
        {
            rightFell = true;
            SwapParticles(upRight, downRight);
        }
        else if (IsMovableBySeawater(upLeft, random) && IsMovableBySeawater(downLeft, random))
        {
            SwapParticles(upRight, downLeft);
        }
    }
}

void MoveSeawaterLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, bool leftFell, bool rightFell)
{
    if (random < 0.8 &&
        ((upLeft.type == SEAWATER && IsMovableBySeawater(upRight, random) && !leftFell) ||
        (upRight.type == SEAWATER && IsMovableBySeawater(upLeft, random) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (random < 0.5 &&
        ((downLeft.type == SEAWATER && IsMovableBySeawater(downRight, random) && !leftFell) ||
        (downRight.type == SEAWATER && IsMovableBySeawater(downLeft, random) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdateSeawater(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB)
{
    VaporizeSeawater(upLeft, upRight, downLeft, downRight, randomA, randomB);

    bool leftFell = false;
    bool rightFell = false;
    MoveSeawaterDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveSeawaterLaterally(upLeft, upRight, downLeft, downRight, randomB, leftFell, rightFell);
}
