#version 460 core

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

#include "Particles.glsl"

uniform ivec2 size;
uniform uint frame;
uniform uint globalSeed;

layout(std430) restrict readonly buffer inputParticles {
    Particle InputParticles[];
};

layout(std430) restrict writeonly buffer outputParticles {
    Particle OutputParticles[];
};

#include "Hash.glsl"

ivec2 GetMargolusOffset()
{
    switch (frame % 4)
    {
        case 0: return ivec2(0, 0);
        case 1: return ivec2(1, 1);
        case 2: return ivec2(0, 1);
        case 3: return ivec2(1, 0);
    }
}

uint GetPositionId(ivec2 position)
{
    return position.y * size.x + position.x;
}

Particle GetParticle(ivec2 position)
{
    return (position.x < 0 || position.x >= size.x || position.y < 0 || position.y >= size.y) ?
        Particle(WALL, 0) : InputParticles[GetPositionId(position)];
}

void SwapParticles(inout Particle particle1, inout Particle particle2)
{
    Particle temp = particle1;
    particle1 = particle2;
    particle2 = temp;
}

#include "UpdateSand.glsl"

void UpdateParticles(inout Particle topLeft, inout Particle topRight, inout Particle bottomRight,
    inout Particle bottomLeft, float randomA, float randomB, float randomC)
{
    UpdateSand(topLeft, topRight, bottomRight, bottomLeft, randomA);
}

void SetUpdatedParticle(ivec2 position, ivec2 offset, Particle topLeft, Particle topRight,
    Particle bottomRight, Particle bottomLeft)
{
    uint globalParticleId = GetPositionId(position);
    ivec2 localParticlePosition = (position + offset) & 1;
    uint localParticleId = localParticlePosition.y * 2 + localParticlePosition.x;

    switch (localParticleId)
    {
        case 0:
            OutputParticles[globalParticleId] = bottomLeft;
            break;
        case 1:
            OutputParticles[globalParticleId] = bottomRight;
            break;
        case 2:
            OutputParticles[globalParticleId] = topLeft;
            break;
        case 3:
            OutputParticles[globalParticleId] = topRight;
            break;
    }
}

void main()
{
    ivec2 position = ivec2(gl_GlobalInvocationID.xy);

    if (position.x >= size.x || position.y >= size.y)
		return;

    ivec2 offset = GetMargolusOffset();
    ivec2 evenPosition = ((position + offset) / 2) * 2 - offset;

    Particle topLeft = GetParticle(evenPosition + ivec2(0, 1));
    Particle topRight = GetParticle(evenPosition + ivec2(1, 1));
    Particle bottomRight = GetParticle(evenPosition + ivec2(1, 0));
    Particle bottomLeft = GetParticle(evenPosition);

    float randomA = HashVec2(evenPosition);
    float randomB = HashVec2(evenPosition + randomA);
    float randomC = HashVec2(evenPosition + randomB);

    UpdateParticles(topLeft, topRight, bottomRight, bottomLeft, randomA, randomB, randomC);
    SetUpdatedParticle(position, offset, topLeft, topRight, bottomRight, bottomLeft);
}
