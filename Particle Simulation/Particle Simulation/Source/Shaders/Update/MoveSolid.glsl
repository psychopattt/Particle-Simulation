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
    inout Particle upRight, inout Particle downLeft, inout Particle downRight, vec4 random)
{
    float diagonalRandom = diagonalMultiplier < 0 ? 1 : random.x * diagonalMultiplier;
    MoveSolid(type, upLeft, upRight, downLeft, downRight, random.x, diagonalRandom);
    MoveSolid(type, upRight, upLeft, downRight, downLeft, random.x, diagonalRandom);
}
