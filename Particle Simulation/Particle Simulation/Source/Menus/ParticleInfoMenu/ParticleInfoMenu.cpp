#include "ParticleInfoMenu.h"

#include "imgui/imgui.h"

#include "Settings/SandboxSettings.h"

using namespace ImGui;

ParticleInfoMenu::ParticleInfoMenu()
{
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
		
	}

	End();
}
