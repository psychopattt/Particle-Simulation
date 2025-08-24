#include "SandboxMouseHandler.h"

#include "GLFW/glfw3.h"
#include "imgui/imgui.h"

#include "Settings/DrawSettings.h"
#include "Settings/TransformSettings.h"
#include "Simulation/SimulationMath/SimulationMath.h"

SandboxMouseHandler::SandboxMouseHandler()
{
	if (GLFW_MOUSE_BUTTON_LAST + 1 < DrawSettings::MouseButtonCount)
		DrawSettings::MouseButtonCount = GLFW_MOUSE_BUTTON_LAST + 1;
}

void SandboxMouseHandler::ApplyZoom(bool scrolledUp, bool scrolledDown)
{
	using DrawSettings::DrawRadius;

	if (DrawSettings::DrawMode)
	{
		float radiusChange = TransformSettings::SpeedMultiplier / 10.0f;

		if (scrolledUp)
			DrawRadius += radiusChange;
		else if (scrolledDown)
			DrawRadius = DrawRadius - radiusChange > 1 ? DrawRadius - radiusChange : 1;
	}
	else
	{
		MouseHandler::ApplyZoom(scrolledUp, scrolledDown);
	}
}

void SandboxMouseHandler::ApplyMousePan()
{
	if (DrawSettings::DrawMode)
	{
		TransformSettings::MousePanEnabled = false;
		UpdateDrawSettings();
	}
	else
	{
		DrawSettings::Drawing = false;
		MouseHandler::ApplyMousePan();
	}
}

void SandboxMouseHandler::UpdateDrawSettings()
{
	UpdateDrawPositions();
	DrawSettings::Drawing = false;

	for (int button = 0; button < DrawSettings::MouseButtonCount; button++)
	{
		if (GetButton(button))
		{
			DrawSettings::DrawType = DrawSettings::SelectedParticles[button];
			DrawSettings::Drawing = DrawSettings::DrawType > -1;
			ImGui::SetWindowFocus(NULL);
			break;
		}
	}
}

void SandboxMouseHandler::UpdateDrawPositions()
{
	using DrawSettings::CurrentPositionX, DrawSettings::CurrentPositionY;

	int mousePositionX, mousePositionY;
	SimulationMath::ComputeMousePixelCoords(mousePositionX, mousePositionY);

	DrawSettings::LastPositionX = DrawSettings::Drawing ? CurrentPositionX : mousePositionX;
	DrawSettings::LastPositionY = DrawSettings::Drawing ? CurrentPositionY : mousePositionY;
	CurrentPositionX = mousePositionX;
	CurrentPositionY = mousePositionY;
}
