void UpdateMethane(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float randomA, float randomB)
{
    MoveGas(METHANE, 1.17, upLeft, upRight, downLeft, downRight, randomA, randomB);
}
