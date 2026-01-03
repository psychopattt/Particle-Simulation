void UpdateAir(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveGas(AIR, 1, upLeft, upRight, downLeft, downRight, random);
}
