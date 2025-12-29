bool CanIgniteFire(Particle particle)
{
    switch (particle.type)
    {
        case FIRE: return true;
        case LAVA: return true;
        default: return false;
    }
}

bool CanCatchFire(Particle particle, float random)
{
    switch (particle.type)
    {
        case WOOD: return random < 0.07;
        case KEROSENE: return random < 0.18;
        case SAWDUST: return random < 0.13;
        case VINE: return random < 0.1;
        case METHANE: return random < 0.38;
        case AMMONIA: return random < 0.003;
        default: return false;
    }
}

bool CanQuenchFire(Particle particle, float random)
{
    switch (particle.type)
    {
        case WATER: return random < 0.175;
        case SEAWATER: return random < 0.172;
        default: return false;
    }
}

void SpreadFire(inout Particle particle, float random)
{
    if (CanCatchFire(particle, random))
        particle = CreateParticle(FIRE, particle.shade);
}

void SpreadFire(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (CanIgniteFire(upLeft) || CanIgniteFire(upRight) ||
        CanIgniteFire(downLeft) || CanIgniteFire(downRight))
    {
        SpreadFire(upLeft, random);
        SpreadFire(upRight, random);
        SpreadFire(downLeft, random);
        SpreadFire(downRight, random);
    }
}

void QuenchFire(inout Particle particle, float random)
{
    if (particle.type == FIRE)
        particle = CreateParticle(random < 0.3 ? SMOKE : AIR, particle.shade);
}

void QuenchFireByParticle(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    bool quench = CanQuenchFire(upLeft, random) || CanQuenchFire(upRight, random) ||
        CanQuenchFire(downLeft, random) || CanQuenchFire(downRight, random);

    if (quench)
    {
        QuenchFire(upLeft, 0);
        QuenchFire(upRight, 0);
        QuenchFire(downLeft, 0);
        QuenchFire(downRight, 0);
    }
}

void QuenchFireByFlammability(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomC)
{
    float averageFlammability = 0.25 * (
        float(CanCatchFire(upLeft, 0) || CanIgniteFire(upLeft)) +
        float(CanCatchFire(upRight, 0) || CanIgniteFire(upRight)) +
        float(CanCatchFire(downLeft, 0) || CanIgniteFire(downLeft)) +
        float(CanCatchFire(downRight, 0) || CanIgniteFire(downRight))
    );

    float quenchProbability = 0.102 - (averageFlammability * 0.1);

    if (randomA < quenchProbability)
    {
        QuenchFire(downLeft, randomC);
        QuenchFire(downRight, randomC);
    }
}

void QuenchFire(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomC)
{
    QuenchFireByParticle(upLeft, upRight, downLeft, downRight, randomC);
    QuenchFireByFlammability(upLeft, upRight, downLeft, downRight, randomA, randomC);
}

void UpdateFireShade(inout Particle particle, float random)
{
    if (particle.type == FIRE)
        particle.shade = HashVec2(vec2(random, particle.shade)) - 0.5;
}

void UpdateFireShade(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (random < 0.15)
    {
        UpdateFireShade(upLeft, random);
        UpdateFireShade(upRight, random);
        UpdateFireShade(downLeft, random);
        UpdateFireShade(downRight, random);
    }
}

bool TryMoveFire(inout Particle origin, inout Particle target, float random)
{
    if (origin.type == FIRE)
    {
        origin.phase = PHASE_SOLID;
        bool movable = CanMoveParticle(origin, target, random);
        origin.phase = PHASE_STATIC;

        if (movable)
            SwapParticles(origin, target);

        return movable;
    }

    return false;
}

void MoveFireLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    TryMoveFire(upLeft, upRight, random) ||
        TryMoveFire(upRight, upLeft, random);

    TryMoveFire(downLeft, downRight, random) ||
        TryMoveFire(downRight, downLeft, random);
}

void MoveFireSideVertically(inout Particle origin, inout Particle mainTarget,
    inout Particle secondaryTarget, float random)
{
    TryMoveFire(origin, mainTarget, random) ||
        TryMoveFire(origin, secondaryTarget, random);
}

void MoveFireVertically(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomB, float randomC)
{
    if (randomB < 0.5)
    {
        MoveFireSideVertically(upLeft, downLeft, downRight, randomC);
        MoveFireSideVertically(upRight, downRight, downLeft, randomC);
    }
    else
    {
        MoveFireSideVertically(downLeft, upLeft, upRight, randomC);
        MoveFireSideVertically(downRight, upRight, upLeft, randomC);
    }
}

void UpdateFire(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    SpreadFire(upLeft, upRight, downLeft, downRight, randomA);
    QuenchFire(upLeft, upRight, downLeft, downRight, randomA, randomC);
    UpdateFireShade(upLeft, upRight, downLeft, downRight, randomA);
    MoveFireLaterally(upLeft, upRight, downLeft, downRight, randomB);
    MoveFireVertically(upLeft, upRight, downLeft, downRight, randomB, randomC);
}
