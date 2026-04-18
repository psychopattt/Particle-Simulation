#pragma once

#include "Interface/ImGui/ImGuiWindow/ImGuiWindow.h"

enum Position : signed char;
enum DisplayFlags : unsigned char;

class ParticleInfoMenu : public ImGuiWindow
{
	public:
		ParticleInfoMenu();
		void Render() override;

	private:
		Position position;
		DisplayFlags displayFlags;
		const int padding = 10;
		int windowFlags;

		void ApplyPosition();
		void RenderMainMenu();
		void RenderDisplayMenu();
		void RenderDisplaySelectable(const char* label, DisplayFlags value);
		void RenderPositionMenu();
		void RenderPositionSelectable(const char* label, Position value);
};
