#include "Inputs/SandboxKeyboardHandler/SandboxKeyboardHandler.h"
#include "Inputs/SandboxMouseHandler/SandboxMouseHandler.h"
#include "Menus/ParticlesMenu/ParticlesMenu.h"
#include "Menus/SandboxMenu/SandboxMenu.h"
#include "Menus/WindowsMenu/WindowsMenu.h"
#include "Simulation/Sandbox.h"
#include "OCSFW.h"

int main()
{
	Sandbox simulation = Sandbox(256, 144);
	SandboxKeyboardHandler keyboardHandler = SandboxKeyboardHandler();
	SandboxMouseHandler mouseHandler = SandboxMouseHandler();

	WindowsMenu windowsMenu = WindowsMenu();
	SandboxMenu sandboxMenu = SandboxMenu();
	ParticlesMenu particlesMenu = ParticlesMenu();
	ImGuiWindow* menus[] = { &windowsMenu, &sandboxMenu, &particlesMenu };

	OCSFW(&simulation)
		.WithTitle("Particle Simulation")
		.WithMenus(menus, std::size(menus))
		.WithKeyboardHandler(&keyboardHandler)
		.WithMouseHandler(&mouseHandler)
		.Run();

	return EXIT_SUCCESS;
}
