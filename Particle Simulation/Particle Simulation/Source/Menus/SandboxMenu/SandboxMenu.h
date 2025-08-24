#pragma once

#include "Interface/ImGui/ImGuiWindow/ImGuiWindow.h"

class SandboxMenu : public ImGuiWindow
{
	public:
		void Initialize() override;
		void Render() override;
};
