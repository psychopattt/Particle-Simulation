#include "ParticleInfoMenu.h"

#include "imgui/imgui.h"

#include "Settings/SandboxSettings.h"

using namespace ImGui;

enum Position : signed char
{
	Custom = -2,
	Center = -1,
	TopLeft = 0,
	TopRight = 1,
	BottomLeft = 2,
	BottomRight = 3
};

ParticleInfoMenu::ParticleInfoMenu()
{
	position = BottomRight;
	windowFlags = ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_AlwaysAutoResize |
		ImGuiWindowFlags_NoSavedSettings | ImGuiWindowFlags_NoNavInputs;
}

void ParticleInfoMenu::Render()
{
	if (!SandboxSettings::ShowParticleInfo)
		return;

	SetNextWindowBgAlpha(0.75f);

	if (Begin("Particle Info", &SandboxSettings::ShowParticleInfo, windowFlags))
	{
		RenderMainMenu();
	}

	End();
}

void ParticleInfoMenu::RenderMainMenu()
{
	if (BeginPopupContextWindow())
	{
		if (BeginMenu("Position"))
			RenderPositionMenu();

		if (MenuItem("Close"))
			SandboxSettings::ShowParticleInfo = false;

		EndPopup();
	}
}

void ParticleInfoMenu::RenderPositionMenu()
{
	RenderPositionSelectable("Custom", Custom);
	RenderPositionSelectable("Center", Center);
	RenderPositionSelectable("Top Left", TopLeft);
	RenderPositionSelectable("Top Right", TopRight);
	RenderPositionSelectable("Bottom Left", BottomLeft);
	RenderPositionSelectable("Bottom Right", BottomRight);
	EndMenu();
}

void ParticleInfoMenu::RenderPositionSelectable(const char* label, Position value)
{
	if (Selectable(label, position == value))
		position = value;
}
