#pragma once

#include "Inputs/MouseHandler/MouseHandler.h"

class SandboxMouseHandler : public MouseHandler
{
	public:
		SandboxMouseHandler();

	protected:
		void ApplyZoom(bool scrolledUp, bool scrolledDown) override;
		void ApplyMousePan() override;

	private:
		void UpdateDrawSettings();
		void UpdateDrawPositions();
};
