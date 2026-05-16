void UpdateAmmonia(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveGas(AMMONIA, 1.12, upLeft, upRight, downLeft, downRight, random);
}
