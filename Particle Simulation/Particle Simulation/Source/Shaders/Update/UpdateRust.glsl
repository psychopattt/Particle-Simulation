void UpdateRust(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    MoveSolid(RUST, 1, upLeft, upRight, downLeft, downRight, random);
}
