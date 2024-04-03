# Depth Based Metal Outline Shader

To generate outlines, I sample adjacent pixels and compare their values. 
If the values are very different, an edge will be drawn. 

I sample pixels from the depth buffer in a X shape, roughly centered around the current pixel being rendered.

You can read more about it in this great article:
https://roystan.net/articles/outline-shader/

The same as in Unity with HLSL, but written in Swift using SCNTechnique and Metal.

![depth](https://github.com/DmitryBakcheev/DepthBasedOutline/assets/95116816/dbf29fa4-b6c4-4f39-8def-87658e5cbb94)
