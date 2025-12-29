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

void MoveSeawaterSideDown(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random, inout bool fell)
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

void MoveSeawaterDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    MoveSeawaterSideDown(upLeft, upRight, downLeft, downRight, random, leftFell);
    MoveSeawaterSideDown(upRight, upLeft, downRight, downLeft, random, rightFell);
}

void MoveSeawaterLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, bool leftFell, bool rightFell)
{
    if (random < 0.8 &&
        ((upLeft.type == SEAWATER && CanMoveParticle(upLeft, upRight, random) && !leftFell) ||
        (upRight.type == SEAWATER && CanMoveParticle(upRight, upLeft, random) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (random < 0.5 &&
        ((downLeft.type == SEAWATER && CanMoveParticle(downLeft, downRight, random) && !leftFell) ||
        (downRight.type == SEAWATER && CanMoveParticle(downRight, downLeft, random) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdateSeawater(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    VaporizeSeawater(upLeft, upRight, downLeft, downRight, randomA, randomB);

    bool leftFell = false;
    bool rightFell = false;
    MoveSeawaterDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveSeawaterLaterally(upLeft, upRight, downLeft, downRight, randomB, leftFell, rightFell);
}
