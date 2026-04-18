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

	ApplyPosition();
	SetNextWindowBgAlpha(0.75f);

	if (Begin("Particle Info", &SandboxSettings::ShowParticleInfo, windowFlags))
	{
		RenderMainMenu();
	}

	End();
}

void ParticleInfoMenu::ApplyPosition()
{
	if (position == Custom)
	{
		windowFlags &= ~ImGuiWindowFlags_NoMove;
	}
	else if (position == Center)
	{
		SetNextWindowPos(GetMainViewport()->GetCenter(), ImGuiCond_Always, ImVec2(0.5f, 0.5f));
		windowFlags |= ImGuiWindowFlags_NoMove;
	}
	else
	{
		const ImGuiViewport* viewport = GetMainViewport();
		ImVec2 workSize = viewport->WorkSize;
		ImVec2 workPos = viewport->WorkPos;

		ImVec2 windowPos = ImVec2(
			(position & 1) ? (workPos.x + workSize.x - padding) : (workPos.x + padding),
			(position & 2) ? (workPos.y + workSize.y - padding) : (workPos.y + padding)
		);

		ImVec2 windowPivot = ImVec2(
			(position & 1) ? 1.0f : 0.0f,
			(position & 2) ? 1.0f : 0.0f
		);

		SetNextWindowPos(windowPos, ImGuiCond_Always, windowPivot);
		windowFlags |= ImGuiWindowFlags_NoMove;
	}
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
