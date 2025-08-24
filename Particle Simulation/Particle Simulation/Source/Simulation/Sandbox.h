#pragma once

#include <memory>

#include "Simulation/Simulation.h"

using std::unique_ptr;

class Sandbox : public Simulation
{
	public:
		Sandbox(int width, int height, unsigned int seed = 0);
		void Initialize(int width, int height, unsigned int seed = 0) override;
		void Restart() override;
		void Execute() override;
		void Draw() override;
		~Sandbox();

	private:
		void InitializeRenderTexture();
		void InitializeShaders();
		void ExecuteDrawMode();

		unique_ptr<class Texture> texture;
		unique_ptr<class SimulationDrawer> simDrawer;
		unique_ptr<class DualComputeBuffer> particlesBuffers;

		unique_ptr<class ComputeShader> initShader;
		unique_ptr<class ComputeShader> updateShader;
		unique_ptr<class ComputeShader> drawShader;
		unique_ptr<class ComputeShader> colorShader;
};
