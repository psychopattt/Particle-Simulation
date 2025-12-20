#version 460 core

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

#include "Particle.glsl"

uniform ivec2 size;

layout(std430) restrict writeonly buffer particlesBuffer {
    Particle Particles[];
};

#include "Particles.glsl"

void main()
{
    ivec2 position = ivec2(gl_GlobalInvocationID.xy);

    if (position.x >= size.x || position.y >= size.y)
		return;

    uint id = position.y * size.x + position.x;
    Particles[id] = CreateParticle(VOID, 0);
}
