void UpdateSand(inout Particle topLeft, inout Particle topRight, inout Particle bottomRight, inout Particle bottomLeft, float random)
{
    if (topLeft.type == SAND)
    {
        if (bottomLeft.type == VOID)
        {
            if (random < 0.9)
                SwapParticles(topLeft, bottomLeft);
        }
        else if (topRight.type == VOID && bottomRight.type == VOID)
        {
            SwapParticles(topLeft, bottomRight);
        }
    }

    if (topRight.type == SAND)
    {
        if (bottomRight.type == VOID)
        {
            if (random < 0.9)
                SwapParticles(topRight, bottomRight);
        }
        else if (topLeft.type == VOID && bottomLeft.type == VOID)
        {
            SwapParticles(topRight, bottomLeft);
        }
    }
}
