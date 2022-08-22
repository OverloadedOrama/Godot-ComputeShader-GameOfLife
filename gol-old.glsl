#[compute]
#version 450

// Ported from https://github.com/WorldOfZero/UnityVisualizations/blob/master/GameOfLife/ConwaysGameOfLifeSimulation.compute

layout(local_size_x = 8, local_size_y = 1, local_size_z = 1) in;
layout(set = 0, binding = 0, rgba32f) uniform image2D target_image;

void main() {
	ivec2 index = ivec2(gl_GlobalInvocationID.xy);
	vec4 currentPixel = imageLoad(target_image, index);

	vec4 neighborPixels = vec4(0, 0, 0, 0);
	// +Y
	neighborPixels += imageLoad(target_image, index + ivec2(1, 1));
	neighborPixels += imageLoad(target_image, index + ivec2(0, 1));
	neighborPixels += imageLoad(target_image, index + ivec2(-1, 1));
	// Neutral Y
	neighborPixels += imageLoad(target_image, index + ivec2(1, 0));
	neighborPixels += imageLoad(target_image, index + ivec2(-1, 0));
	// -Y
	neighborPixels += imageLoad(target_image, index + ivec2(1, -1));
	neighborPixels += imageLoad(target_image, index + ivec2(0, -1));
	neighborPixels += imageLoad(target_image, index + ivec2(-1, -1));

	imageStore(target_image, index, imageLoad(target_image, index - ivec2(1, 1)));
	// Add current pixel for reason
	//neighborPixels += currentPixel;

//  	if (currentPixel.r > 0.5) {
//  		if (neighborPixels.r > 1.5 && neighborPixels.r < 3.5) { // Between 2 and 3
//  			imageStore(target_image, index, vec4(1, 1, 1, 1));
//  		}
//  		else {
//  			imageStore(target_image, index, vec4(0, 0, 0, 1));
//  		}
//  	}
//  	else {
//  		if (neighborPixels.r > 2.5 && neighborPixels.r < 3.5) { // == 3
//  			imageStore(target_image, index, vec4(1, 1, 1, 1));
//  		}
//  		else {
//  			imageStore(target_image, index, vec4(0, 0, 0, 1));
//  		}
//  	}
}
