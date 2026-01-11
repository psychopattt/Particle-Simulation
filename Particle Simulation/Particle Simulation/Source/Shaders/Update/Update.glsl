#version 460 core

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

#include "Particle.glsl"

uniform ivec2 size;
uniform uint frame;
uniform uint globalSeed;

layout(std430) restrict readonly buffer inputParticles {
    Particle InputParticles[];
};

layout(std430) restrict writeonly buffer outputParticles {
    Particle OutputParticles[];
};

#include "Particles.glsl"
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
        CreateParticle(WALL, 0) : InputParticles[GetPositionId(position)];
}

bool CanMoveParticle(Particle origin, Particle target, float random)
{
    float densityDelta = origin.density - target.density;
    float moveProbability = min(0.9, densityDelta / origin.density);
    bool immovable = origin.phase == PHASE_STATIC || target.phase == PHASE_STATIC;
    bool mixable = target.phase > PHASE_SOLID;

    return !immovable && mixable && random < moveProbability;
}

void SwapParticles(inout Particle particle1, inout Particle particle2)
{
    Particle temp = particle1;
    particle1 = particle2;
    particle2 = temp;
}

#include "MoveGas.glsl"
#include "MoveLiquid.glsl"
#include "MoveSolid.glsl"

#include "UpdateAir.glsl"
#include "UpdateSand.glsl"
#include "UpdateWater.glsl"
#include "UpdateSmoke.glsl"
#include "UpdateFire.glsl"
#include "UpdateStone.glsl"
#include "UpdatePetrol.glsl"
#include "UpdateSteam.glsl"
#include "UpdateSeawater.glsl"
#include "UpdateLava.glsl"
#include "UpdateIce.glsl"
#include "UpdateSalt.glsl"
#include "UpdateSawdust.glsl"
#include "UpdateAcid.glsl"
#include "UpdateVine.glsl"
#include "UpdateRust.glsl"
#include "UpdateIron.glsl"
#include "UpdateMethane.glsl"
#include "UpdateAmmonia.glsl"
#include "UpdateChlorine.glsl"
#include "UpdateWax.glsl"
#include "UpdateMercury.glsl"

void UpdateParticles(inout Particle upLeft, inout Particle upRight,
    inout Particle downLeft, inout Particle downRight, vec4 random)
{
    UpdateAir(upLeft, upRight, downLeft, downRight, random);
    UpdateSand(upLeft, upRight, downLeft, downRight, random);
    UpdateWater(upLeft, upRight, downLeft, downRight, random);
    UpdateSmoke(upLeft, upRight, downLeft, downRight, random);
    UpdateFire(upLeft, upRight, downLeft, downRight, random);
    UpdateStone(upLeft, upRight, downLeft, downRight, random);
    UpdatePetrol(upLeft, upRight, downLeft, downRight, random);
    UpdateSteam(upLeft, upRight, downLeft, downRight, random);
    UpdateSeawater(upLeft, upRight, downLeft, downRight, random);
    UpdateLava(upLeft, upRight, downLeft, downRight, random);
    UpdateIce(upLeft, upRight, downLeft, downRight, random);
    UpdateSalt(upLeft, upRight, downLeft, downRight, random);
    UpdateSawdust(upLeft, upRight, downLeft, downRight, random);
    UpdateAcid(upLeft, upRight, downLeft, downRight, random);
    UpdateVine(upLeft, upRight, downLeft, downRight, random);
    UpdateRust(upLeft, upRight, downLeft, downRight, random);
    UpdateIron(upLeft, upRight, downLeft, downRight, random);
    UpdateMethane(upLeft, upRight, downLeft, downRight, random);
    UpdateAmmonia(upLeft, upRight, downLeft, downRight, random);
    UpdateChlorine(upLeft, upRight, downLeft, downRight, random);
    UpdateWax(upLeft, upRight, downLeft, downRight, random);
    UpdateMercury(upLeft, upRight, downLeft, downRight, random);
}

void SetUpdatedParticle(ivec2 position, ivec2 offset, Particle upLeft, Particle upRight,
    Particle downLeft, Particle downRight)
{
    uint globalParticleId = GetPositionId(position);
    ivec2 localParticlePosition = (position + offset) & 1;
    uint localParticleId = localParticlePosition.y * 2 + localParticlePosition.x;

    switch (localParticleId)
    {
        case 0:
            OutputParticles[globalParticleId] = downLeft;
            break;
        case 1:
            OutputParticles[globalParticleId] = downRight;
            break;
        case 2:
            OutputParticles[globalParticleId] = upLeft;
            break;
        case 3:
            OutputParticles[globalParticleId] = upRight;
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

    Particle upLeft = GetParticle(evenPosition + ivec2(0, 1));
    Particle upRight = GetParticle(evenPosition + ivec2(1, 1));
    Particle downRight = GetParticle(evenPosition + ivec2(1, 0));
    Particle downLeft = GetParticle(evenPosition);

    float randomX = HashVec2(evenPosition);
    float randomY = HashVec2(evenPosition + randomX);
    float randomZ = HashVec2(evenPosition + randomY);
    float randomW = HashVec2(evenPosition + randomZ);
    vec4 random = vec4(randomX, randomY, randomZ, randomW);

    UpdateParticles(upLeft, upRight, downLeft, downRight, random);
    SetUpdatedParticle(position, offset, upLeft, upRight, downLeft, downRight);
}
