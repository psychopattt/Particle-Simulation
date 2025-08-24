#include "SandboxKeyboardHandler.h"

#include "GLFW/glfw3.h"
#include "imgui/imgui.h"

#include "Settings/DrawSettings.h"

void SandboxKeyboardHandler::HandleKeyboard(GLFWwindow* window,
	int key, int scanCode, int action, int mods)
{
	if (!ImGui::GetIO().WantCaptureKeyboard)
	{
		ApplyDrawMode(key, action);
	}

	ApplyDrawOverwrite(key, action);
	KeyboardHandler::HandleKeyboard(window, key, scanCode, action, mods);
}

void SandboxKeyboardHandler::ApplyDrawMode(int key, int action)
{
	if (key == GLFW_KEY_E && action == GLFW_PRESS)
		DrawSettings::DrawMode = !DrawSettings::DrawMode;
}

void SandboxKeyboardHandler::ApplyDrawOverwrite(int key, int action)
{
	if (key == GLFW_KEY_LEFT_SHIFT)
		DrawSettings::Overwrite = action != GLFW_RELEASE;
}
