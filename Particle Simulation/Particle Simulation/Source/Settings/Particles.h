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
	Water,
	Wall,

	ParticleCount
};

inline const char* ParticleLabels[] = {
	"Clear",
	"Sand",
	"Water",
	"Wall"
};
