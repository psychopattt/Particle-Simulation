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
        case SAND: return vec3(0.82, 0.82, 0) + (particle.shade * 0.125);
        case WATER: return vec3(0, 0, 0.8) + (particle.shade * 0.025);
        case WALL: return vec3(0.293) + (particle.shade * 0.01);
        case WOOD: return vec3(0.275, 0.157, 0) + (particle.shade * 0.02);
        case SMOKE: return vec3(0.22) + (particle.shade * 0.2);
        case FIRE: return vec3(0.8, (particle.shade + 0.5) * 0.75, 0);
        case STONE: return vec3(0.24) + (particle.shade * 0.025);
        case KEROSENE: return vec3(0.73, particle.shade * 0.015 + 0.6, 0.08);
        case STEAM: return vec3(0.78) + (particle.shade * 0.03);
        case SEAWATER: return vec3(0, 0.1, 0.7) + (particle.shade * 0.015);
        case LAVA: return vec3(0.76, particle.shade * 0.05 + 0.33, 0);
        case ICE: return vec3(particle.shade * 0.34 + 0.17, 0.49, 0.7);
        case SALT: return vec3(0.98, 0.97, 0.94) + (particle.shade * 0.04);
        case SAWDUST: return particle.shade * vec3(0, 0.05, 0.1) + vec3(0.67, 0.54, 0.33);
        case ACID: return vec3(particle.shade * 0.3 + 0.25, 0.9, 0);
        case VINE: return vec3(0, particle.shade * 0.15 + 0.225, 0.1);
        case RUST: return particle.shade * vec3(0.46, 0.16, 0) + vec3(0.34, 0.12, 0);
        case IRON: return particle.shade * 0.01 + vec3(0.31, 0.34, 0.39);
        case METHANE: return particle.shade * 0.02 + vec3(0.8, 0.65, 0.65);
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
