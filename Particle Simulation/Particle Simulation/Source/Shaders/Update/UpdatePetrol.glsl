void MovePetrolSideDown(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random, inout bool fell)
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

void MovePetrolDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    MovePetrolSideDown(upLeft, upRight, downLeft, downRight, random, leftFell);
    MovePetrolSideDown(upRight, upLeft, downRight, downLeft, random, rightFell);
}

void MovePetrolLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, bool leftFell, bool rightFell)
{
    if (random < 0.8 &&
        ((upLeft.type == PETROL && CanMoveParticle(upLeft, upRight, random) && !leftFell) ||
        (upRight.type == PETROL && CanMoveParticle(upRight, upLeft, random) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (random < 0.5 &&
        ((downLeft.type == PETROL && CanMoveParticle(downLeft, downRight, random) && !leftFell) ||
        (downRight.type == PETROL && CanMoveParticle(downRight, downLeft, random) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdatePetrol(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    bool leftFell = false;
    bool rightFell = false;
    MovePetrolDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MovePetrolLaterally(upLeft, upRight, downLeft, downRight, randomB, leftFell, rightFell);
}
