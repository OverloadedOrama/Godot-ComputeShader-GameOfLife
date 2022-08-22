#[compute]

#version 450

// Ported from https://github.com/WorldOfZero/UnityVisualizations/blob/master/GameOfLife/ConwaysGameOfLifeSimulation.compute

layout(local_size_x = 8, local_size_y = 1, local_size_z = 1) in;
layout(set = 0, binding = 0, rgba32f) uniform image2D target_image;

//layout(set = 0, binding = 0, rgba32f) writeonly uniform image2D color_buffer;

void main() {
	ivec2 index = ivec2(gl_GlobalInvocationID.xy);
// 	ivec2 size = imageSize(target_image);
	//vec2 position = (vec2(index) + 0.5) / vec2(size);
// 	vec2 pixelSize = vec2(1.0 / size.x, 1.0 / size.y);

// 	vec4 currentPixel = imageLoad(target_image, ivec2(position.x, position.y));
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

	// +Y
// 	neighborPixels += imageLoad(target_image, ivec2(position.x + pixelSize.x, position.y + pixelSize.y));
// 	neighborPixels += imageLoad(target_image, ivec2(position.x, position.y + pixelSize.y));
// 	neighborPixels += imageLoad(target_image, ivec2(position.x - pixelSize.x, position.y + pixelSize.y));
// 	// Neutral Y
// 	neighborPixels += imageLoad(target_image, ivec2(position.x + pixelSize.x, position.y));
// 	neighborPixels += imageLoad(target_image, ivec2(position.x - pixelSize.x, position.y));
// 	// -Y
// 	neighborPixels += imageLoad(target_image, ivec2(position.x + pixelSize.x, position.y - pixelSize.y));
// 	neighborPixels += imageLoad(target_image, ivec2(position.x, position.y - pixelSize.y));
// 	neighborPixels += imageLoad(target_image, ivec2(position.x - pixelSize.x, position.y - pixelSize.y));

	// Add current pixel for reason
	//neighborPixels += currentPixel;

 	if (currentPixel.r > 0.5) {
 		if (neighborPixels.r > 1.5 && neighborPixels.r < 3.5) { // Between 2 and 3
 			imageStore(target_image, index, vec4(1, 1, 1, 1));
 		}
 		else {
 			imageStore(target_image, index, vec4(0, 0, 0, 1));
 		}
 	}
 	else {
 		if (neighborPixels.r > 2.5 && neighborPixels.r < 3.5) { // == 3
 			imageStore(target_image, index, vec4(1, 1, 1, 1));
 		}
 		else {
 			imageStore(target_image, index, vec4(0, 0, 0, 1));
 		}
 	}
// 	imageStore(target_image, index, vec4(0, 1, 0, 0.5));
// 	imageStore(target_image, index, imageLoad(target_image, index - ivec2(1)));
// 	imageStore(target_image, index, currentPixel);
// 	imageStore(target_image, index, neighborPixels / 9.0);

// 	if (index.x >= size.x || index.y >= size.y) {
// 		return;
// 	}
//
// 	vec2 uv = (vec2(index) + 0.5) / vec2(size);
// 	imageStore(target_image, index, vec4(uv, 0, 1.0));
	//uint gid = gl_GlobalInvocationID.x;
	//color_buffer.data[gid] = gid;
}
