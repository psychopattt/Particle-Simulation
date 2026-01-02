void UpdateStone(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveSolid(STONE, 10, upLeft, upRight, downLeft, downRight, random);
}
