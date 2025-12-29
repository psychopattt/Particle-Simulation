#include "Sandbox.h"

#include "glad/gl.h"

#include "Settings/Particles.h"
#include "Settings/DrawSettings.h"
#include "Settings/SandboxSettings.h"
#include "Shaders/Buffers/Texture/Texture.h"
#include "Shaders/ComputeShader/ComputeShader.h"
#include "Shaders/Buffers/DualComputeBuffer/DualComputeBuffer.h"
#include "Simulation/SimulationDrawer/SimulationDrawer.h"

Sandbox::Sandbox(int width, int height, unsigned int seed) :
	Simulation(width, height, seed) { };

void Sandbox::Initialize(int width, int height, unsigned int seed)
{
	using std::make_unique;

	Simulation::Initialize(width, height, seed);

	SandboxSettings::Frame = 0;
	simDrawer = make_unique<SimulationDrawer>();
	particlesBuffers = make_unique<DualComputeBuffer>(sizeof(Particle) * width * height);

	InitializeRenderTexture();
	InitializeShaders();
}

void Sandbox::InitializeRenderTexture()
{
	texture = std::make_unique<Texture>(width, height);

	float outOfBoundsColor[] = { 0.05f, 0.05f, 0.05f, 1 };
	glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, outOfBoundsColor);
}

void Sandbox::InitializeShaders()
{
	using std::make_unique;

	initShader = make_unique<ComputeShader>("Initialize", width, height);
	initShader->SetBufferBinding("particlesBuffer", particlesBuffers->GetId(1));
	initShader->SetUniform("size", width, height);
	initShader->Execute();

	updateShader = make_unique<ComputeShader>("Update", width, height);
	updateShader->SetUniform("size", width, height);
	updateShader->SetUniform("globalSeed", seed);

	drawShader = make_unique<ComputeShader>("Draw", width, height);
	drawShader->SetUniform("size", width, height);
	drawShader->SetUniform("globalSeed", seed);

	colorShader = make_unique<ComputeShader>("Color", width, height);
	colorShader->SetTextureBinding("texture", texture->GetId());
	colorShader->SetUniform("size", width, height);
}

void Sandbox::Restart()
{
	Simulation::Initialize();
}

void Sandbox::Execute()
{
	particlesBuffers->Swap();

	updateShader->SetBufferBinding("inputParticles", particlesBuffers->GetId(0));
	updateShader->SetBufferBinding("outputParticles", particlesBuffers->GetId(1));
	updateShader->SetUniform("frame", SandboxSettings::Frame++);
	updateShader->Execute();
}

void Sandbox::Draw()
{
	using DrawSettings::AirColor;

	ExecuteDrawMode();

	colorShader->SetUniform("airColor", AirColor[0], AirColor[1], AirColor[2]);
	colorShader->SetBufferBinding("particlesBuffer", particlesBuffers->GetId(1));
	colorShader->Execute();

	simDrawer->Draw(texture.get());
}

void Sandbox::ExecuteDrawMode()
{
	if (DrawSettings::Drawing)
	{
		drawShader->SetBufferBinding("particlesBuffer", particlesBuffers->GetId(1));
		drawShader->SetUniform("lastPosition", DrawSettings::LastPositionX, DrawSettings::LastPositionY);
		drawShader->SetUniform("currentPosition", DrawSettings::CurrentPositionX, DrawSettings::CurrentPositionY);
		drawShader->SetUniform("drawRadius", DrawSettings::DrawRadius);
		drawShader->SetUniform("overwrite", DrawSettings::Overwrite);
		drawShader->SetUniform("drawType", DrawSettings::DrawType);
		drawShader->SetUniform("frame", SandboxSettings::Frame);
		drawShader->Execute();
	}
}

Sandbox::~Sandbox() { }
