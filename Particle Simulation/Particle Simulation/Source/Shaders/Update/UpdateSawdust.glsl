void UpdateSawdust(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveSolid(SAWDUST, 1, upLeft, upRight, downLeft, downRight, random);
}
