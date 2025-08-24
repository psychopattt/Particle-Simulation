#pragma once

#include "Settings/Particles.h"

namespace DrawSettings
{
	inline bool DrawMode = true;
	inline bool Drawing = false;
	inline bool Overwrite = false;
	inline float VoidColor[3] = { 0, 0, 0 };
	inline float DrawRadius = 2.5f;
	inline int DrawType = 0;

	inline int LastPositionX = 0;
	inline int LastPositionY = 0;
	inline int CurrentPositionX = 0;
	inline int CurrentPositionY = 0;

	inline constexpr int MaxMouseButtonCount = 8;
	inline int MouseButtonCount = MaxMouseButtonCount;
	inline constexpr unsigned int MouseButtonColors[MaxMouseButtonCount] = {
		0xFF000080, 0xFF750000, 0xFFDDDDDD, 0xFF3182F5,
		0xFF19E1FF, 0xFFFFBEDC, 0xFFF4D442, 0xFF4B19E6
	};

	inline int SelectedParticles[MaxMouseButtonCount] = {
		static_cast<int>(ParticleType::Sand),
		static_cast<int>(ParticleType::Void),
		-1, -1, -1, -1, -1, -1
	};
}
