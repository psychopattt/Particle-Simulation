void MoveRustSide(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random)
{
    if (moving.type == RUST)
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

void UpdateRust(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveRustSide(upLeft, upRight, downLeft, downRight, random);
    MoveRustSide(upRight, upLeft, downRight, downLeft, random);
}
