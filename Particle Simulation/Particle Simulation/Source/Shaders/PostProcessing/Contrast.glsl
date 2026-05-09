#version 460 core

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

uniform float brightness;
uniform float saturation;
uniform float contrast;

layout(rgba32f) restrict uniform image2D texture;

void main()
{
    ivec2 position = ivec2(gl_GlobalInvocationID.xy);
    vec3 color = imageLoad(texture, position).rgb * brightness;

    const vec3 luminanceCoefficient = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(color, luminanceCoefficient));

	color = mix(intensity, color, saturation);
	color = mix(vec3(0.5), color, contrast);

    imageStore(texture, position, vec4(color, 1));
}
