#pragma once

#include "Interface/ImGui/ImGuiWindow/ImGuiWindow.h"
#include "Settings/Particles.h"

class ParticlesMenu : public ImGuiWindow
{
	public:
		void Initialize() override;
		void Render() override;

	private:
		void SortParticles();
		void RenderParticles();
		void RenderParticle(int particleId, const char* label, float width);
		bool IsParticleSelected(int particleId, bool hovered) const;
		void PushMouseButtonColors(int button, bool hovered) const;
		void UpdateParticleSelection(int particleId);
		void SwapParticleButton(int particleId, int newButton) const;
		
		int hoveredParticle = -1;
		int lastHoveredParticle = -1;
		int sortedParticleIds[static_cast<int>(ParticleType::ParticleCount)];

		const float itemSpacing = 15;
		const float itemPadding = itemSpacing / 2;
		const int particleCount = static_cast<int>(ParticleType::ParticleCount);
};
