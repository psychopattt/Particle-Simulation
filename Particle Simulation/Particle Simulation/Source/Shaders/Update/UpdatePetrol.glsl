void MovePetrolDown(inout Particle moving, Particle side, inout Particle bottom,
    inout Particle diagonal, inout bool fell, float random)
{
    if (moving.type == PETROL)
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

void MovePetrolDown(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, inout bvec2 fell, float random)
{
    MovePetrolDown(upLeft, upRight, downLeft, downRight, fell.x, random);
    MovePetrolDown(upRight, upLeft, downRight, downLeft, fell.y, random);
}

void MovePetrolLaterally(inout Particle left, inout Particle right, bvec2 fell, float random)
{
    if ((left.type == PETROL && !fell.x && CanMoveParticle(left, right, random)) ||
        (right.type == PETROL && !fell.y && CanMoveParticle(right, left, random)))
    {
        SwapParticles(left, right);
    }
}

void MovePetrolLaterally(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, bvec2 fell, float random)
{
    MovePetrolLaterally(upLeft, upRight, fell, random * 1.125);
    MovePetrolLaterally(downLeft, downRight, fell, random * 1.8);
}

void UpdatePetrol(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    bvec2 fell = bvec2(false);
    MovePetrolDown(upLeft, upRight, downLeft, downRight, fell, randomA);
    MovePetrolLaterally(upLeft, upRight, downLeft, downRight, fell, randomB);
}
