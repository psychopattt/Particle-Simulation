#pragma once

#include "Inputs/KeyboardHandler/KeyboardHandler.h"

class SandboxKeyboardHandler : public KeyboardHandler
{
	public:
		void HandleKeyboard(struct GLFWwindow* window,
			int key, int scanCode, int action, int mods) override;

	private:
		void ApplyDrawMode(int key, int action);
		void ApplyDrawOverwrite(int key, int action);
};
