#include "ParticlesMenu.h"

#include "imgui/imgui.h"

#include "Settings/Particles.h"
#include "Settings/DrawSettings.h"
#include "Settings/SandboxSettings.h"

using namespace ImGui;

void ParticlesMenu::Initialize()
{
	particleCount = static_cast<int>(ParticleType::ParticleCount);

	if (ImGuiMouseButton_COUNT < DrawSettings::MouseButtonCount)
		DrawSettings::MouseButtonCount = ImGuiMouseButton_COUNT;
}

void ParticlesMenu::Render()
{
	if (!SandboxSettings::ShowParticles)
		return;

	SetNextWindowPos(ImVec2(530, 10), ImGuiCond_FirstUseEver);
	SetNextWindowSize(ImVec2(500, -1), ImGuiCond_FirstUseEver);

	if (Begin("Particles", &SandboxSettings::ShowParticles, ImGuiWindowFlags_NoNavInputs))
	{
		PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(itemSpacing, itemSpacing));
		PushStyleVar(ImGuiStyleVar_DisabledAlpha, 1);
		RenderParticles();
		PopStyleVar(2);
	}

	End();
}

void ParticlesMenu::RenderParticles()
{
	BeginDisabled();
	const char* label = ParticleLabels[0];
	float itemWidth = CalcTextSize(label).x;
	float maxWindowPositionX = GetCursorScreenPos().x + GetContentRegionAvail().x;
	lastHoveredParticle = hoveredParticle;
	hoveredParticle = -1;

	for (int particleId = 0; particleId < particleCount; particleId++)
	{
		RenderParticle(particleId, label, itemWidth);

		if (particleId + 1 < particleCount)
		{
			label = ParticleLabels[particleId + 1];
			itemWidth = CalcTextSize(label).x;
			float nextItemPositionX = GetItemRectMax().x + itemPadding + itemWidth;

			if (nextItemPositionX < maxWindowPositionX)
				SameLine();
		}
	}

	EndDisabled();
}

void ParticlesMenu::RenderParticle(int particleId, const char* label, float width)
{
	bool hovered = particleId == lastHoveredParticle;
	bool selected = IsParticleSelected(particleId, hovered);
	Selectable(label, hovered || selected, ImGuiSelectableFlags_None, ImVec2(width, 0));
	UpdateParticleSelection(particleId);
	
	if (selected)
		PopStyleColor(3);
}

bool ParticlesMenu::IsParticleSelected(int particleId, bool hovered) const
{
	for (int button = 0; button < DrawSettings::MouseButtonCount; button++)
	{
		if (DrawSettings::SelectedParticles[button] == particleId)
		{
			PushMouseButtonColors(button, hovered);
			return true;
		}
	}

	return false;
}

void ParticlesMenu::PushMouseButtonColors(int button, bool hovered) const
{
	ImU32 itemColor = DrawSettings::MouseButtonColors[button] - (hovered ? 0x55000000 : 0);
	PushStyleColor(ImGuiCol_Text, button < 2 ? 0xFFFFFFFF : 0xFF000000);
	PushStyleColor(ImGuiCol_HeaderHovered, itemColor);
	PushStyleColor(ImGuiCol_Header, itemColor);
}

void ParticlesMenu::UpdateParticleSelection(int particleId)
{
	if (!IsItemHovered(ImGuiHoveredFlags_AllowWhenDisabled))
		return;

	hoveredParticle = particleId;

	for (int button = 0; button < DrawSettings::MouseButtonCount; button++)
	{
		if (IsMouseReleased(button))
		{
			SwapParticleButton(particleId, button);
			break;
		}
	}
}

void ParticlesMenu::SwapParticleButton(int particleId, int newButton) const
{
	using DrawSettings::SelectedParticles;

	for (int oldButton = 0; oldButton < DrawSettings::MouseButtonCount; oldButton++)
	{
		if (oldButton != newButton && SelectedParticles[oldButton] == particleId)
		{
			SelectedParticles[oldButton] = SelectedParticles[newButton];
			break;
		}
	}

	SelectedParticles[newButton] = particleId;
}
