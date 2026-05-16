void UpdateRock(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveSolid(ROCK, 10, upLeft, upRight, downLeft, downRight, random);
}
