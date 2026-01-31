bool CanDissolveFoam(Particle particle, float random)
{
    switch (particle.type)
    {
        case LAVA: return random < 0.11;
        case PETROL: return random < 0.04;
        case METHANE: return random < 0.003;
        case CHLORINE: return random < 0.012;
        default: return false;
    }
}

void DissolveFoam(inout Particle particle, float random)
{
    if (particle.type == FOAM)
    {
        int type = random > 0.18 ? AIR : (random > 0.01 ? SMOKE : AMMONIA);
        float shade = HashVec2(vec2(random, particle.shade)) - 0.5;
        particle = CreateParticle(type, shade);
    }
}

void DissolveFoam(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    if (CanDissolveFoam(upRight, random.x) || CanDissolveFoam(downLeft, random.x))
    {
        DissolveFoam(upLeft, random.z);
        DissolveFoam(downRight, random.z);
    }

    if (CanDissolveFoam(upLeft, random.y) || CanDissolveFoam(downRight, random.y))
    {
        DissolveFoam(upRight, random.z);
        DissolveFoam(downLeft, random.z);
    }
}

void ExpandFoam(inout Particle origin, inout Particle target)
{
    if (origin.type == FOAM)
    {
        if (origin.phase == PHASE_STATIC && origin.shade < 100)
        {
            origin.shade += 0.9;

            if (target.phase == PHASE_GAS)
            {
                origin.density -= 36.7;
                origin.shade += 5;
                target = origin;
            }
        }
        else if (origin.shade > 5.5)
        {
            origin.phase = PHASE_STATIC;
        }
        else
        {
            origin.shade += 0.04;
        }
    }
}

void ExpandFoam(inout Particle origin1, inout Particle origin2,
    inout Particle target1, inout Particle target2, float random)
{
    if (random < 0.25)
        ExpandFoam(origin1, target1);
    else if (random < 0.5)
        ExpandFoam(origin1, target2);
    else if (random < 0.75)
        ExpandFoam(origin2, target1);
    else
        ExpandFoam(origin2, target2);
}

void UpdateFoam(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    DissolveFoam(upLeft, upRight, downLeft, downRight, random);
    ExpandFoam(upLeft, downRight, upRight, downLeft, random.x);
    ExpandFoam(upRight, downLeft, upLeft, downRight, random.y);
    MoveLiquid(FOAM, upLeft, upRight, downLeft, downRight, random);
}
