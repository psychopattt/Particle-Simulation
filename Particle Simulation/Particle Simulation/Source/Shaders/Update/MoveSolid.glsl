void MoveSolid(int type, inout Particle moving, Particle side, inout Particle bottom,
    inout Particle diagonal, float bottomRandom, float diagonalRandom)
{
    if (moving.type == type)
    {
        if (CanMoveParticle(moving, bottom, bottomRandom))
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

void MoveSolid(int type, float diagonalMultiplier, inout Particle upLeft,
    inout Particle upRight, inout Particle downLeft, inout Particle downRight, float random)
{
    float diagonalRandom = random * diagonalMultiplier;
    MoveSolid(type, upLeft, upRight, downLeft, downRight, random, diagonalRandom);
    MoveSolid(type, upRight, upLeft, downRight, downLeft, random, diagonalRandom);
}
