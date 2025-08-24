#include "WindowsMenu.h"

#include "imgui/imgui.h"

#include "Settings/SandboxSettings.h"

using namespace ImGui;

void WindowsMenu::Render()
{
	if (Begin("Settings"))
	{
		if (CollapsingHeader("Windows"))
		{
			Checkbox("Sandbox Settings", &SandboxSettings::ShowSandboxSettings);
			Checkbox("Particles", &SandboxSettings::ShowParticles);
		}
	}

	End();
}
