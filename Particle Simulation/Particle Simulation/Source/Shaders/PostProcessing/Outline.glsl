#version 460 core

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

#include "Particle.glsl"

uniform ivec2 size;
uniform vec3 outlineColor;

layout(rgba32f) restrict writeonly uniform image2D texture;
layout(std430) restrict readonly buffer particlesBuffer {
    Particle Particles[];
};

#include "Particles.glsl"

bool PositionValid(ivec2 position)
{
    return position.x >= 0 && position.x < size.x &&
        position.y >= 0 && position.y < size.y;
}

bool ParticleVisible(ivec2 position)
{
    uint particleId = position.y * size.x + position.x;
    return Particles[particleId].type != AIR;
}

bool HasVisibleNeighbor(ivec2 position)
{
    for (int y = -1; y < 2; y++)
    {
        for (int x = -1; x < 2; x++)
        {
            ivec2 neighborPosition = position + ivec2(x, y);

            if (PositionValid(neighborPosition) && ParticleVisible(neighborPosition))
                return true;
        }
    }

    return false;
}

void main()
{
    ivec2 position = ivec2(gl_GlobalInvocationID.xy);

    if (PositionValid(position) && !ParticleVisible(position) && HasVisibleNeighbor(position))
        imageStore(texture, position, vec4(outlineColor, 1));
}
