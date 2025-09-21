bool CanIgniteFire(Particle particle)
{
    switch (particle.type)
    {
        case FIRE: return true;
        default: return false;
    }
}

bool CanCatchFire(Particle particle, float random)
{
    switch (particle.type)
    {
        case WOOD: return random < 0.07;
        case KEROSENE: return random < 0.18;
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

bool IsMovableByFire(Particle particle)
{
    switch (particle.type)
    {
        case VOID: return true;
        case SMOKE: return true;
        default: return false;
    }
}

void SpreadFire(inout Particle particle, float random)
{
    if (CanCatchFire(particle, random))
        particle.type = FIRE;
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
        particle.type = random < 0.3 ? SMOKE : VOID;
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

void QuenchFire(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomC)
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

void MoveFireLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (random < 0.1)
    {
        if ((upLeft.type == FIRE && IsMovableByFire(upRight)) ||
            (upRight.type == FIRE && IsMovableByFire(upLeft)))
        {
            SwapParticles(upLeft, upRight);
        }

        if ((downLeft.type == FIRE && IsMovableByFire(downRight)) ||
            (downRight.type == FIRE && IsMovableByFire(downLeft)))
        {
            SwapParticles(downLeft, downRight);
        }
    }
}

void MoveFireDown(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (random < 0.2)
    {
        if (upLeft.type == FIRE)
        {
            if (IsMovableByFire(downLeft))
                SwapParticles(upLeft, downLeft);
            else if (IsMovableByFire(downRight))
                SwapParticles(upLeft, downRight);
        }

        if (upRight.type == FIRE)
        {
            if (IsMovableByFire(downRight))
                SwapParticles(upRight, downRight);
            else if (IsMovableByFire(downLeft))
                SwapParticles(upRight, downLeft);
        }
    }
}

void MoveFireUp(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    if (random < 0.2)
    {
        if (downLeft.type == FIRE)
        {
            if (IsMovableByFire(upLeft))
                SwapParticles(downLeft, upLeft);
            else if (IsMovableByFire(upRight))
                SwapParticles(downLeft, upRight);
        }

        if (downRight.type == FIRE)
        {
            if (IsMovableByFire(upRight))
                SwapParticles(downRight, upRight);
            else if (IsMovableByFire(upLeft))
                SwapParticles(downRight, upLeft);
        }
    }
}

void UpdateFire(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB, float randomC)
{
    SpreadFire(upLeft, upRight, downLeft, downRight, randomA);
    QuenchFire(upLeft, upRight, downLeft, downRight, randomA, randomC);
    UpdateFireShade(upLeft, upRight, downLeft, downRight, randomA);
    MoveFireLaterally(upLeft, upRight, downLeft, downRight, randomB);

    if (randomB < 0.5)
        MoveFireDown(upLeft, upRight, downLeft, downRight, randomC);
    else
        MoveFireUp(upLeft, upRight, downLeft, downRight, randomC);
}
