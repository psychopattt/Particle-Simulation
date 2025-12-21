#include "SandboxMenu.h"

#include "imgui/imgui.h"

#include "Settings/DrawSettings.h"
#include "Settings/SandboxSettings.h"

using namespace ImGui;

void SandboxMenu::Initialize()
{
	SetColorEditOptions(ImGuiColorEditFlags_PickerHueWheel);
}

void SandboxMenu::Render()
{
	if (!SandboxSettings::ShowSandboxSettings)
		return;

	SetNextWindowPos(ImVec2(270, 10), ImGuiCond_FirstUseEver);
	SetNextWindowSize(ImVec2(250, -1), ImGuiCond_FirstUseEver);

	if (Begin("Sandbox Settings", &SandboxSettings::ShowSandboxSettings))
	{
		PushItemWidth(-1);

		Checkbox("Draw Mode", &DrawSettings::DrawMode);
		SameLine();
		TextDisabled("[E]");

		SeparatorText("Draw Radius");
		SliderFloat("##sliderDrawRadius", &DrawSettings::DrawRadius, 1, 50, "%.1f");

		SeparatorText("Background Color");
		ColorEdit3("##editAirColor", DrawSettings::AirColor);

		PopItemWidth();
	}

	End();
}
