#pragma once

struct Particle
{
	int type;
	int phase;
	float density;
	float shade;
};

enum class ParticleType : int
{
	Air,
	Sand,
	Water,
	Wall,
	Wood,
	Smoke,
	Fire,
	Stone,
	Petrol,
	Steam,
	Seawater,
	Lava,
	Ice,
	Salt,
	Sawdust,
	Acid,
	Vine,
	Rust,
	Iron,
	Methane,
	Ammonia,
	Chlorine,

	ParticleCount
};

inline const char* ParticleLabels[] = {
	"Clear",
	"Sand",
	"Water",
	"Wall",
	"Wood",
	"Smoke",
	"Fire",
	"Stone",
	"Petrol",
	"Steam",
	"Seawater",
	"Lava",
	"Ice",
	"Salt",
	"Sawdust",
	"Acid",
	"Vine",
	"Rust",
	"Iron",
	"Methane",
	"Ammonia",
	"Chlorine"
};
