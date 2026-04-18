#pragma once

#include "Interface/ImGui/ImGuiWindow/ImGuiWindow.h"

class ParticleInfoMenu : public ImGuiWindow
{
	public:
		ParticleInfoMenu();
		void Render() override;

	private:
		int windowFlags;
};
