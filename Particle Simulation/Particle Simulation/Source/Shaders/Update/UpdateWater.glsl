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

void MoveWaterDown(inout Particle moving, Particle side, inout Particle bottom,
    inout Particle diagonal, inout bool fell, float random)
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

void MoveWaterDown(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, inout bvec2 fell, float random)
{
    MoveWaterDown(upLeft, upRight, downLeft, downRight, fell.x, random);
    MoveWaterDown(upRight, upLeft, downRight, downLeft, fell.y, random);
}

void MoveWaterLaterally(inout Particle left, inout Particle right, bvec2 fell, float random)
{
    if ((left.type == WATER && !fell.x && CanMoveParticle(left, right, random)) ||
        (right.type == WATER && !fell.y && CanMoveParticle(right, left, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveWaterLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, bvec2 fell, float random)
{
    MoveWaterLaterally(upLeft, upRight, fell, random * 1.125);
    MoveWaterLaterally(downLeft, downRight, fell, random * 1.8);
}

void UpdateWater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    VaporizeWater(upLeft, upRight, downLeft, downRight, randomA, randomB);

    bvec2 fell = bvec2(false);
    MoveWaterDown(upLeft, upRight, downLeft, downRight, fell, randomA);
    MoveWaterLaterally(upLeft, upRight, downLeft, downRight, fell, randomB);
}
