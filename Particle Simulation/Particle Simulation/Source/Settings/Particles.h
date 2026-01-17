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
	Rock,
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
	Wax,
	Mercury,
	Cement,

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
	"Rock",
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
	"Chlorine",
	"Wax",
	"Mercury",
	"Cement"
};
