#pragma once

#include "Interface/ImGui/ImGuiWindow/ImGuiWindow.h"

enum Position : signed char;

class ParticleInfoMenu : public ImGuiWindow
{
	public:
		ParticleInfoMenu();
		void Render() override;

	private:
		Position position;
		int windowFlags;

		void RenderMainMenu();
		void RenderPositionMenu();
		void RenderPositionSelectable(const char* label, Position value);
};
