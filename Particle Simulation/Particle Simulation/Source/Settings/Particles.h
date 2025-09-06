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
	Wood,
	Smoke,

	ParticleCount
};

inline const char* ParticleLabels[] = {
	"Clear",
	"Sand",
	"Water",
	"Wall",
	"Wood",
	"Smoke"
};
