void UpdatePetrol(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    MoveLiquid(PETROL, upLeft, upRight, downLeft, downRight, random);
}
