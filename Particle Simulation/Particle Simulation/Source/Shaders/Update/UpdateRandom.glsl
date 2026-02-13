void RandomizeParticle(inout Particle particle, float random)
{
    if (particle.type == RANDOM)
    {
        int type = min(particleCount - 1, int(particleCount * random));
        particle = CreateParticle(type, particle.shade);
    }
}

void UpdateRandom(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    RandomizeParticle(upLeft, random.x);
    RandomizeParticle(upRight, random.y);
    RandomizeParticle(downLeft, random.z);
    RandomizeParticle(downRight, random.w);
}
