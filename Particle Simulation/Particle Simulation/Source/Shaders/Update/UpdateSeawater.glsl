bool CanVaporizeSeawater(Particle particle, float random)
{
    switch (particle.type)
    {
        case FIRE: return random < 0.0144;
        case LAVA: return random < 0.072;
        default: return false;
    }
}

void VaporizeSeawater(inout Particle particle)
{
    if (particle.type == SEAWATER)
        particle = CreateParticle(STEAM, particle.shade);
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

void MoveSeawaterDown(inout Particle moving, Particle side, inout Particle bottom,
    inout Particle diagonal, inout bool fell, float random)
{
    if (moving.type == SEAWATER)
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

void MoveSeawaterDown(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, inout bvec2 fell, float random)
{
    MoveSeawaterDown(upLeft, upRight, downLeft, downRight, fell.x, random);
    MoveSeawaterDown(upRight, upLeft, downRight, downLeft, fell.y, random);
}

void MoveSeawaterLaterally(inout Particle left, inout Particle right, bvec2 fell, float random)
{
    if ((left.type == SEAWATER && !fell.x && CanMoveParticle(left, right, random)) ||
        (right.type == SEAWATER && !fell.y && CanMoveParticle(right, left, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveSeawaterLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, bvec2 fell, float random)
{
    MoveSeawaterLaterally(upLeft, upRight, fell, random * 1.125);
    MoveSeawaterLaterally(downLeft, downRight, fell, random * 1.8);
}

void UpdateSeawater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    VaporizeSeawater(upLeft, upRight, downLeft, downRight, randomA, randomB);

    bvec2 fell = bvec2(false);
    MoveSeawaterDown(upLeft, upRight, downLeft, downRight, fell, randomA);
    MoveSeawaterLaterally(upLeft, upRight, downLeft, downRight, fell, randomB);
}
