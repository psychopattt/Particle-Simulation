#pragma once

#include "Interface/ImGui/ImGuiWindow/ImGuiWindow.h"

class ParticlesMenu : public ImGuiWindow
{
	public:
		void Initialize() override;
		void Render() override;

	private:
		void RenderParticles();
		void RenderParticle(int particleId, const char* label, float width);
		bool IsParticleSelected(int particleId, bool hovered) const;
		void PushMouseButtonColors(int button, bool hovered) const;
		void UpdateParticleSelection(int particleId);
		void SwapParticleButton(int particleId, int newButton) const;
		
		int particleCount = 0;
		int hoveredParticle = -1;
		int lastHoveredParticle = -1;

		const float itemSpacing = 15;
		const float itemPadding = itemSpacing / 2;
};
