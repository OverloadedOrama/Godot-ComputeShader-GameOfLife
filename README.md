# Game of Life made with a compute shader in Godot 4

Original GLSL compute shader from https://github.com/yumcyaWiz/glsl-compute-shader-sandbox
Textures taken from: https://github.com/WorldOfZero/UnityVisualizations/tree/master/GameOfLife

A compute shader running [Conway's game of life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), made with Godot 4.0.alpha14. The compute shader works with a texture with RBA8 format.

I'm not entirely sure if the implementation is correct. It may not be because I'm not sure how to handle the out-of-bounds area of textures.
