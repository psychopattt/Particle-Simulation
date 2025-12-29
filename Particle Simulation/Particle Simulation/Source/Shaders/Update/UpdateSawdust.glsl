void MoveSawdustSide(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random)
{
    if (moving.type == SAWDUST)
    {
        if (CanMoveParticle(moving, bottom, random))
        {
            SwapParticles(moving, bottom);
        }
        else if (CanMoveParticle(moving, side, random) &&
            CanMoveParticle(moving, diagonal, random))
        {
            SwapParticles(moving, diagonal);
        }
    }
}

void UpdateSawdust(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveSawdustSide(upLeft, upRight, downLeft, downRight, random);
    MoveSawdustSide(upRight, upLeft, downRight, downLeft, random);
}
