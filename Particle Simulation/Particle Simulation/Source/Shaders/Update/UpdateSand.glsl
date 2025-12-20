void UpdateSandSide(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random)
{
    if (moving.type == SAND)
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

void UpdateSand(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    UpdateSandSide(upLeft, upRight, downLeft, downRight, random);
    UpdateSandSide(upRight, upLeft, downRight, downLeft, random);
}
