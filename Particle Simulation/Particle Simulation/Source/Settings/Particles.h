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
	Fire,
	Stone,
	Kerosene,
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
	"Kerosene",
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
