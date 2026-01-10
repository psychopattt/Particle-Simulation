float GetWaxHeatAmount(Particle particle)
{
    switch (particle.type)
    {
        case WATER: return -0.03;
        case FIRE: return 0.9;
        case SEAWATER: return -0.03;
        case LAVA: return 0.08;
        case ICE: return -0.1;
        case WAX: return particle.shade < -1 ? 0.001 : -0.01;
        default: return -0.01;
    }
}

void UpdateWaxTemperature(inout Particle particle, float heatAmount)
{
    if (particle.type == WAX)
    {
        if (particle.shade > -0.5 && heatAmount < 0)
            particle.phase = PHASE_STATIC;
        else if (particle.shade < -6 && heatAmount > 0)
            particle.phase = PHASE_LIQUID;
        else
            particle.shade -= heatAmount;
    }
}

void UpdateWaxTemperature(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, float random)
{
    float cellHeatAmount = random * (
        GetWaxHeatAmount(upLeft) + GetWaxHeatAmount(upRight) +
        GetWaxHeatAmount(downLeft) + GetWaxHeatAmount(downRight)
    );

    UpdateWaxTemperature(upLeft, cellHeatAmount);
    UpdateWaxTemperature(upRight, cellHeatAmount);
    UpdateWaxTemperature(downLeft, cellHeatAmount);
    UpdateWaxTemperature(downRight, cellHeatAmount);
}

void UpdateWax(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    UpdateWaxTemperature(upLeft, upRight, downLeft, downRight, random.z);
    MoveLiquid(WAX, upLeft, upRight, downLeft, downRight, random);
}
