#pragma once

struct Particle
{
	int type;
	float shade;
};

enum class ParticleType : int
{
	Void,
	Sand,
	Wall,

	ParticleCount
};

inline const char* ParticleLabels[] = {
	"Clear",
	"Sand",
	"Wall"
};
