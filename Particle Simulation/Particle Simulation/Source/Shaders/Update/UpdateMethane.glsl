void UpdateMethane(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveGas(METHANE, 1.17, upLeft, upRight, downLeft, downRight, random);
}
