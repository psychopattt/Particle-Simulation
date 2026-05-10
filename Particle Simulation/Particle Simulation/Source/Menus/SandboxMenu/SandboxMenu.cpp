#include "SandboxMenu.h"

#include "imgui/imgui.h"

#include "Settings/DrawSettings.h"
#include "Settings/SandboxSettings.h"
#include "Settings/PostProcessingSettings.h"

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
		RenderDrawSettings();
		RenderPostProcessingSettings();
		PopItemWidth();
	}

	End();
}

void SandboxMenu::RenderDrawSettings()
{
	if (CollapsingHeader("Draw Settings", ImGuiTreeNodeFlags_DefaultOpen))
	{
		Checkbox("Draw Mode", &DrawSettings::DrawMode);
		SameLine();
		TextDisabled("[E]");

		SeparatorText("Draw Radius");
		SliderFloat("##sliderDrawRadius", &DrawSettings::DrawRadius, 1, 50, "%.1f");
	}
}

void SandboxMenu::RenderPostProcessingSettings()
{
	using namespace PostProcessingSettings;

	if (CollapsingHeader("Post-Processing"))
	{
		SeparatorText("Background Color");
		ColorEdit3("##editAirColor", AirColor);

		SeparatorText("Outline");
		Checkbox("##checkOutline", &DrawOutline);
		SameLine();
		ColorEdit3("##editOutlineColor", OutlineColor);

		SeparatorText("Brightness");
		SliderFloat("##sliderBrightness", &Brightness, 0, 3, "%.2f");

		SeparatorText("Saturation");
		SliderFloat("##sliderSaturation", &Saturation, 0, 3, "%.2f");

		SeparatorText("Contrast");
		SliderFloat("##sliderContrast", &Contrast, 0, 3, "%.2f");
	}
}
