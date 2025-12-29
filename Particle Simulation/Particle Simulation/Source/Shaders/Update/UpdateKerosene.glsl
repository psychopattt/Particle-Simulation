void MoveKeroseneSideDown(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random, inout bool fell)
{
    if (moving.type == KEROSENE)
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

void MoveKeroseneDown(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, inout bool leftFell, inout bool rightFell)
{
    MoveKeroseneSideDown(upLeft, upRight, downLeft, downRight, random, leftFell);
    MoveKeroseneSideDown(upRight, upLeft, downRight, downLeft, random, rightFell);
}

void MoveKeroseneLaterally(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float random, bool leftFell, bool rightFell)
{
    if (random < 0.8 &&
        ((upLeft.type == KEROSENE && CanMoveParticle(upLeft, upRight, random) && !leftFell) ||
        (upRight.type == KEROSENE && CanMoveParticle(upRight, upLeft, random) && !rightFell)))
    {
        SwapParticles(upLeft, upRight);
    }

    if (random < 0.5 &&
        ((downLeft.type == KEROSENE && CanMoveParticle(downLeft, downRight, random) && !leftFell) ||
        (downRight.type == KEROSENE && CanMoveParticle(downRight, downLeft, random) && !rightFell)))
    {
        SwapParticles(downLeft, downRight);
    }
}

void UpdateKerosene(inout Particle upLeft, inout Particle upRight, inout Particle downLeft,
    inout Particle downRight, float randomA, float randomB)
{
    bool leftFell = false;
    bool rightFell = false;
    MoveKeroseneDown(upLeft, upRight, downLeft, downRight, randomA, leftFell, rightFell);
    MoveKeroseneLaterally(upLeft, upRight, downLeft, downRight, randomB, leftFell, rightFell);
}
