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
        case PETROL: return random < 0.18;
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
        particle = CreateParticle(FIRE, 0);
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
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float averageFlammability = 0.25 * (
        float(CanCatchFire(upLeft, 0) || CanIgniteFire(upLeft)) +
        float(CanCatchFire(upRight, 0) || CanIgniteFire(upRight)) +
        float(CanCatchFire(downLeft, 0) || CanIgniteFire(downLeft)) +
        float(CanCatchFire(downRight, 0) || CanIgniteFire(downRight))
    );

    float quenchProbability = 0.102 - (averageFlammability * 0.1);

    if (random.x < quenchProbability)
    {
        QuenchFire(downLeft, random.z);
        QuenchFire(downRight, random.z);
    }
}

void QuenchFire(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    QuenchFireByParticle(upLeft, upRight, downLeft, downRight, random.z);
    QuenchFireByFlammability(upLeft, upRight, downLeft, downRight, random);
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
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    if (random.y < 0.5)
    {
        MoveFireSideVertically(upLeft, downLeft, downRight, random.z);
        MoveFireSideVertically(upRight, downRight, downLeft, random.z);
    }
    else
    {
        MoveFireSideVertically(downLeft, upLeft, upRight, random.z);
        MoveFireSideVertically(downRight, upRight, upLeft, random.z);
    }
}

void UpdateFire(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    SpreadFire(upLeft, upRight, downLeft, downRight, random.x);
    QuenchFire(upLeft, upRight, downLeft, downRight, random);
    UpdateFireShade(upLeft, upRight, downLeft, downRight, random.x);
    MoveFireLaterally(upLeft, upRight, downLeft, downRight, random.y);
    MoveFireVertically(upLeft, upRight, downLeft, downRight, random);
}
