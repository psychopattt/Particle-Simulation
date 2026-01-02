void UpdateStone(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveSolid(STONE, 10, upLeft, upRight, downLeft, downRight, random);
}
