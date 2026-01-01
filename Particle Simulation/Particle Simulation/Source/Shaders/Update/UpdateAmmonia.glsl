void UpdateAmmonia(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    MoveGas(AMMONIA, 1.12, upLeft, upRight, downLeft, downRight, randomA, randomB);
}
