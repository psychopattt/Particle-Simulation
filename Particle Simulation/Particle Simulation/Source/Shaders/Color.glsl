#version 460 core

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

#include "Particles.glsl"

uniform ivec2 size;
uniform vec3 voidColor;

layout(rgba32f) restrict writeonly uniform image2D texture;
layout(std430) restrict readonly buffer particlesBuffer {
    Particle Particles[];
};

vec3 GetParticleColor(Particle particle)
{
    switch (particle.type)
    {
        case VOID: return voidColor;
        case SAND: return vec3(0.82, 0.82, 0) + (particle.shade / 8);
        case WALL: return vec3(0.293) + (particle.shade / 100);
        default: return vec3(1, 0, 1);
    }
}

void main()
{
    ivec2 position = ivec2(gl_GlobalInvocationID.xy);

    if (position.x >= size.x || position.y >= size.y)
		return;

    uint id = position.y * size.x + position.x;
    vec3 color = GetParticleColor(Particles[id]);
    imageStore(texture, position, vec4(color, 1));
}
