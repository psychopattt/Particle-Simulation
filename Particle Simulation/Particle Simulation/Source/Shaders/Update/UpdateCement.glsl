void HardenCement(inout Particle particle)
{
    if (particle.type == CEMENT)
    {
        if (particle.shade < -10.48)
        {
            particle.phase = PHASE_STATIC;
        }
        else
        {
            particle.shade -= 0.0052;
            particle.density += 0.04;
        }
    }
}

void HardenCement(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight)
{
    HardenCement(upLeft);
    HardenCement(upRight);
    HardenCement(downLeft);
    HardenCement(downRight);
}

void UpdateCement(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    HardenCement(upLeft, upRight, downLeft, downRight);
    MoveLiquid(CEMENT, upLeft, upRight, downLeft, downRight, random);
}
