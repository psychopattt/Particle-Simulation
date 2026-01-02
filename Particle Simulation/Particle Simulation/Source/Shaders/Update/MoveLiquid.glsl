void MoveLiquidDown(int type, inout Particle moving, Particle side,
    inout Particle bottom, inout Particle diagonal, inout bool fell, float random)
{
    if (moving.type == type)
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

void MoveLiquidDown(int type, inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, inout bvec2 fell, float random)
{
    MoveLiquidDown(type, upLeft, upRight, downLeft, downRight, fell.x, random);
    MoveLiquidDown(type, upRight, upLeft, downRight, downLeft, fell.y, random);
}

void MoveLiquidLaterally(int type, inout Particle left,
    inout Particle right, bvec2 fell, float random)
{
    if ((left.type == type && !fell.x && CanMoveParticle(left, right, random)) ||
        (right.type == type && !fell.y && CanMoveParticle(right, left, random)))
    {
        SwapParticles(left, right);
    }
}

void MoveLiquidLaterally(int type, inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, bvec2 fell, float random)
{
    MoveLiquidLaterally(type, upLeft, upRight, fell, random * 1.125);
    MoveLiquidLaterally(type, downLeft, downRight, fell, random * 1.8);
}

void MoveLiquid(int type, inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    bvec2 fell = bvec2(false);
    MoveLiquidDown(type, upLeft, upRight, downLeft, downRight, fell, random.x);
    MoveLiquidLaterally(type, upLeft, upRight, downLeft, downRight, fell, random.y);
}
