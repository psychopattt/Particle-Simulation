void UpdateSand(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveSolid(SAND, 1, upLeft, upRight, downLeft, downRight, random);
}
