void CloneParticle(Particle cloner, Particle origin, inout Particle target, vec4 random)
{
    bool cloneable = cloner.type == CLONER && origin.type != CLONER;
    bool replaceable = origin.type == AIR && target.type != CLONER || target.type == AIR;

    if (cloneable && replaceable)
    {
        float shade = GenerateShade(random.x, random.y);
        target = CreateParticle(origin.type, shade);
    }
}

void CloneParticle(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    if (random.z < 0.25)
        CloneParticle(upLeft, upRight, downLeft, random);
    else if (random.z < 0.5)
        CloneParticle(upRight, upLeft, downRight, random);
    else if (random.z < 0.75)
        CloneParticle(downLeft, downRight, upLeft, random);
    else
        CloneParticle(downRight, downLeft, upRight, random);
}

void UpdateCloner(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    CloneParticle(upLeft, upRight, downLeft, downRight, random);
}
