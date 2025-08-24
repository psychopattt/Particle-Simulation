#version 460 core

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

#include "Particles.glsl"

uniform ivec2 size;
uniform uint frame;
uniform uint globalSeed;

uniform bool overwrite;
uniform ivec2 lastPosition;
uniform ivec2 currentPosition;
uniform float drawRadius;
uniform int drawType;

layout(std430) restrict buffer particlesBuffer {
    Particle Particles[];
};

#include "Hash.glsl"

float LineDistance(vec2 lineStart, vec2 lineEnd, vec2 point)
{
    vec2 pointToStart = point - lineStart;
    vec2 endToStart = lineEnd - lineStart;
    float heightOnLine = clamp(dot(pointToStart, endToStart) /
        dot(endToStart, endToStart), 0, 1);

    return length(pointToStart - endToStart * heightOnLine);
}

void main()
{
    ivec2 position = ivec2(gl_GlobalInvocationID.xy);

    if (position.x >= size.x || position.y >= size.y)
		return;

    uint id = position.y * size.x + position.x;
    float distance = LineDistance(lastPosition, currentPosition, position);
    bool writeable = overwrite || drawType == VOID || Particles[id].type == VOID;

    if (distance < drawRadius && writeable)
    {
        vec2 shadeSeed = distance * 1.1031 + position;
        Particles[id] = Particle(drawType, HashVec2(shadeSeed) - 0.5);
    }
}
