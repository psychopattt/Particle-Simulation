void UpdateSawdust(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveSolid(SAWDUST, 1, upLeft, upRight, downLeft, downRight, random);
}
