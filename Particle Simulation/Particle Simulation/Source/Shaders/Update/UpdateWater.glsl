bool CanVaporizeWater(Particle particle, float random)
{
    switch (particle.type)
    {
        case FIRE: return random < 0.014;
        case LAVA: return random < 0.07;
        default: return false;
    }
}

void VaporizeWater(inout Particle particle)
{
    if (particle.type == WATER)
        particle = CreateParticle(STEAM, particle.shade);
}

void VaporizeWater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    float vaporizeProbability = 0.25 * (
        float(CanVaporizeWater(upLeft, randomB)) +
        float(CanVaporizeWater(upRight, randomB)) +
        float(CanVaporizeWater(downLeft, randomB)) +
        float(CanVaporizeWater(downRight, randomB))
    );

    if (randomA < vaporizeProbability)
    {
        VaporizeWater(upLeft);
        VaporizeWater(upRight);
        VaporizeWater(downLeft);
        VaporizeWater(downRight);
    }
}

void MoveWaterSideDown(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random, inout bool fell)
{
    if (moving.type == WATER)
    {
        if (CanMoveParticle(moving, bottom, random))
        {
            fell = true;
            SwapParticles(moving, bottom);
        }
        else if (CanMoveParticle(moving, side, random) &&
            CanMoveParticle(moving, diagonal, random))
        {
            SwapParticles(moving, diagonal);
        }
    }
}

void MoveWaterDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    MoveWaterSideDown(upLeft, upRight, downLeft, downRight, random, leftFell);
    MoveWaterSideDown(upRight, upLeft, downRight, downLeft, random, rightFell);
}

void MoveWaterLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, bool leftFell, bool rightFell)
{
    if (random < 0.8 &&
        ((upLeft.type == WATER && CanMoveParticle(upLeft, upRight, random) && !leftFell) ||
        (upRight.type == WATER && CanMoveParticle(upRight, upLeft, random) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (random < 0.5 &&
        ((downLeft.type == WATER && CanMoveParticle(downLeft, downRight, random) && !leftFell) ||
        (downRight.type == WATER && CanMoveParticle(downRight, downLeft, random) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdateWater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    VaporizeWater(upLeft, upRight, downLeft, downRight, randomA, randomB);

    bool leftFell = false;
    bool rightFell = false;
    MoveWaterDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveWaterLaterally(upLeft, upRight, downLeft, downRight, randomB, leftFell, rightFell);
}
