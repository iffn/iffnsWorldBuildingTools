# iffnsWorldBuildingTools
Made with Unity 2019.4.31f1
A collection of multiple tools and shaders that should help with world building.

Shaders:
- Auto Texture shader for terrains and terrain meshes, which shows textures relative to height and steepness. This makes it faster to create new terrains and avoids the use of large splat maps. For terrains, 3 additional custom terrain layers can be used to draw stuff like roads. Only the Albedo channel is currently used by the shader.
- Height hue shader to display areas of equal elevation.
- Steepness shader to display the local steepness. The color switches at a pre-defined angle, 60° by default.
- Map overlay shader to overlay a custom map over the terrain.
Note: All shaders have been created using the Amplify Shader Editor.

Tools:
- Terrain Material Assigner to quickly swap between differnet materials.
- River generator to generate a river mesh using waypoints. The X-size of the waypoints defines the width at that point.
- Terrain exporter tool to export or add the mesh from terrains. (Note: This submodule is not automatically included when downloading the zip because of GitHub being GitHub...)
Note: All tools can be found in Tools -> WorldBuildingTools

![image](https://user-images.githubusercontent.com/18383974/194806904-ce20695c-c70c-4ce0-a1f4-8e93cbc5443c.png)


### Git Submodule integration
Add this submodule with the following git command (Assuming the root of your Git project is the Unity project folder)
```
git submodule add https://github.com/iffn/iffnsWorldBuildingTools.git Assets/iffnsStuff/iffnsWorldBuildingTools
```
