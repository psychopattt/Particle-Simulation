void UpdateStoneSide(inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, float random)
{
    float diagonalRandom = random * 10;

    if (moving.type == STONE)
    {
        if (CanMoveParticle(moving, bottom, random))
        {
            SwapParticles(moving, bottom);
        }
        else if (CanMoveParticle(moving, side, diagonalRandom) &&
            CanMoveParticle(moving, diagonal, diagonalRandom))
        {
            SwapParticles(moving, diagonal);
        }
    }
}

void UpdateStone(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    UpdateStoneSide(upLeft, upRight, downLeft, downRight, random);
    UpdateStoneSide(upRight, upLeft, downRight, downLeft, random);
}
