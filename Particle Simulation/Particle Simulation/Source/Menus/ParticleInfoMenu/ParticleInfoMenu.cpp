#include "ParticleInfoMenu.h"

#include "imgui/imgui.h"

#include "Settings/DrawSettings.h"
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

enum DisplayFlags : unsigned char
{
	None = 0,
	Type = 1 << 0,
	Phase = 1 << 1,
	Density = 1 << 2,
	Shade = 1 << 3,
	Everything = 0xFF
};

ParticleInfoMenu::ParticleInfoMenu()
{
	info.reserve(80);
	position = BottomRight;
	displayFlags = static_cast<DisplayFlags>(Type | Phase);
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
		RenderInfo();
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

void ParticleInfoMenu::RenderInfo()
{
	info.clear();
	const Particle* particle = DrawSettings::HoveredParticle;

	AppendInfo(Type, "Type", particle ? ParticleLabels[particle->type] : "None");
	AppendInfo(Phase, "Phase", particle ? ParticlePhases[particle->phase] : "None");
	AppendInfo(Density, "Density", particle ? FormatInfo(particle->density, 2) : "None");
	AppendInfo(Shade, "Shade", particle ? FormatInfo(particle->shade, 3) : "None");

	Text(info.c_str());
}

std::string ParticleInfoMenu::FormatInfo(float value, int decimals)
{
	char buffer[10];
	snprintf(buffer, std::size(buffer), "%.*f", decimals, value);

	std::string text(buffer);
	text.erase(text.find_last_not_of("0") + 1);
	text.erase(text.find_last_not_of(".") + 1);

	return text;
}

void ParticleInfoMenu::AppendInfo(DisplayFlags type, const char* label, std::string value)
{
	AppendInfo(type, label, value.c_str());
}

void ParticleInfoMenu::AppendInfo(DisplayFlags type, const char* label, const char* value)
{
	if (displayFlags & type)
	{
		if (!info.empty())
			info += "\n";

		info.append(label).append(": ").append(value);
	}
}

void ParticleInfoMenu::RenderMainMenu()
{
	if (BeginPopupContextWindow())
	{
		if (BeginMenu("Display"))
			RenderDisplayMenu();

		if (BeginMenu("Position"))
			RenderPositionMenu();

		if (MenuItem("Close"))
			SandboxSettings::ShowParticleInfo = false;

		EndPopup();
	}
}

void ParticleInfoMenu::RenderDisplayMenu()
{
	RenderDisplaySelectable("Type", Type);
	RenderDisplaySelectable("Phase", Phase);
	RenderDisplaySelectable("Density", Density);
	RenderDisplaySelectable("Shade", Shade);
	EndMenu();
}

void ParticleInfoMenu::RenderDisplaySelectable(const char* label, DisplayFlags value)
{
	if (Selectable(label, displayFlags & value, ImGuiSelectableFlags_NoAutoClosePopups))
		displayFlags = static_cast<DisplayFlags>(displayFlags ^ value);
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
