void UpdateBrick(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveSolid(BRICK, -1, upLeft, upRight, downLeft, downRight, random);
}
