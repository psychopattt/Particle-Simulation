void UpdateMercury(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveLiquid(MERCURY, upLeft, upRight, downLeft, downRight, random);
}
