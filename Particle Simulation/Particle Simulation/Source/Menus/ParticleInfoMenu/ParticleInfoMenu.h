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
		const int padding = 10;
		int windowFlags;

		void ApplyPosition();
		void RenderMainMenu();
		void RenderPositionMenu();
		void RenderPositionSelectable(const char* label, Position value);
};
