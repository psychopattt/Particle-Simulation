void DissolveSalt(inout Particle solvent, inout Particle solute1,
    inout Particle solute2, float random)
{
    if (solvent.type == WATER && random < 0.04)
    {
        Particle air = CreateParticle(AIR, 0);
        solute1.type == SALT ? solute1 = air : solute2 = air;
        solvent = CreateParticle(SEAWATER, solvent.shade);
    }
}

void DissolveSalt(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    if (upRight.type == SALT || downLeft.type == SALT)
    {
        if (random.x < 0.5)
            DissolveSalt(upLeft, downLeft, upRight, random.y);
        else
            DissolveSalt(downRight, upRight, downLeft, random.y);
    }

    if (upLeft.type == SALT || downRight.type == SALT)
    {
        if (random.y < 0.5)
            DissolveSalt(upRight, downRight, upLeft, random.x);
        else
            DissolveSalt(downLeft, upLeft, downRight, random.x);
    }
}

void UpdateSalt(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    DissolveSalt(upLeft, upRight, downLeft, downRight, random);
    MoveSolid(SALT, 1, upLeft, upRight, downLeft, downRight, random);
}
