#pragma once

#include <string>

#include "Interface/ImGui/ImGuiWindow/ImGuiWindow.h"

enum Position : signed char;
enum DisplayFlags : unsigned char;

class ParticleInfoMenu : public ImGuiWindow
{
	public:
		ParticleInfoMenu();
		void Render() override;

	private:
		int windowFlags;
		std::string info;
		Position position;
		DisplayFlags displayFlags;
		const int padding = 10;

		void ApplyPosition();
		void RenderInfo();
		std::string FormatInfo(float value, int decimals);
		void AppendInfo(DisplayFlags type, const char* label, std::string value);
		void AppendInfo(DisplayFlags type, const char* label, const char* value);
		void RenderMainMenu();
		void RenderDisplayMenu();
		void RenderDisplaySelectable(const char* label, DisplayFlags value);
		void RenderPositionMenu();
		void RenderPositionSelectable(const char* label, Position value);
};
