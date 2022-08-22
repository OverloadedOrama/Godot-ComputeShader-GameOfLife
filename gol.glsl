#[compute]
#version 450
// Taken and modifier from https://github.com/yumcyaWiz/glsl-compute-shader-sandbox/blob/main/sandbox/life-game/shaders/update-cells.comp
layout(local_size_x = 8, local_size_y = 8) in;

layout(set = 0, binding = 0, rgba32f) uniform image2D cells_in;
layout(set = 0, binding = 1, rgba32f) uniform image2D cells_out;

uint updateCell(ivec2 cell_idx) {
  float current_status = imageLoad(cells_in, cell_idx).x;

  float alive_cells = 0.0;
  alive_cells += imageLoad(cells_in, cell_idx + ivec2(-1, -1)).x;
  alive_cells += imageLoad(cells_in, cell_idx + ivec2(-1, 0)).x;
  alive_cells += imageLoad(cells_in, cell_idx + ivec2(-1, 1)).x;
  alive_cells += imageLoad(cells_in, cell_idx + ivec2(0, -1)).x;
  alive_cells += imageLoad(cells_in, cell_idx + ivec2(0, 1)).x;
  alive_cells += imageLoad(cells_in, cell_idx + ivec2(1, -1)).x;
  alive_cells += imageLoad(cells_in, cell_idx + ivec2(1, 0)).x;
  alive_cells += imageLoad(cells_in, cell_idx + ivec2(1, 1)).x;

  return uint(current_status < 0.5 && alive_cells > 2.5 && alive_cells < 3.5) + uint(current_status >= 0.5 && alive_cells > 1.5 && alive_cells < 3.5);
}

void main() {
  ivec2 gidx = ivec2(gl_GlobalInvocationID.xy);

  uint next_status = updateCell(gidx);

  imageStore(cells_out, gidx, uvec4(uvec3(next_status), 1));
}
