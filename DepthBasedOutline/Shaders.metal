//
//  Shaders.metal
//  DepthBasedOutline
//
//  Created by Dmitry Bakcheev on 4/3/24.
//


#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float2 texcoord [[attribute(1)]];
    
};

struct VertexOut {
    float4 position [[position]];
    float2 texcoord;
};

struct Symbols {
    float4 size;
    float scale;
    
};


vertex VertexOut myVertexShader(VertexIn in [[stage_in]]) {
    VertexOut out;
    
    out.position = in.position;
    out.texcoord = float2((in.position.x + 1.0 ) * 0.5, (in.position.y + 1.0) * -0.5);
    
    return out;
};


constexpr sampler s = sampler(coord::normalized, address::repeat, filter::nearest);


fragment float4 myFragmentShader(VertexOut in [[stage_in]],
                                 constant Symbols &symbols [[buffer(0)]],
                                 depth2d<float, access::sample> depth [[texture(1)]]) {
    
    float2 pixelSize = float2(1.0 / depth.get_width() , 1.0 / depth.get_height());
    
    
    float halfScaleFloor = floor(symbols.scale * 0.5);
    float halfScaleCeil = ceil(symbols.scale * 0.5);
    
    
    float2 bottomLeftUV = in.texcoord - float2(pixelSize.x, pixelSize.y) * halfScaleFloor;
    float2 topRightUV = in.texcoord + float2(pixelSize.x, pixelSize.y) * halfScaleCeil;
    float2 bottomRightUV = in.texcoord + float2(pixelSize.x * halfScaleCeil, -pixelSize.y * halfScaleFloor);
    float2 topLeftUV = in.texcoord + float2(-pixelSize.x * halfScaleFloor, pixelSize.y * halfScaleCeil);
    
    
    float depth0 = depth.sample(s, bottomLeftUV);
    float depth1 = depth.sample(s, topRightUV);
    float depth2 = depth.sample(s, bottomRightUV);
    float depth3 = depth.sample(s, topLeftUV);
    
    
    float depthFiniteDifference0 = depth1 - depth0;
    float depthFiniteDifference1 = depth3 - depth2;
    
    
    float edgeDepth = sqrt(pow(depthFiniteDifference0, 2) + pow(depthFiniteDifference1, 2)) * 10;
    
    
    edgeDepth = edgeDepth > 0.2 ? 0 : 1;
    
    
    return edgeDepth;
    
    
};



fragment float4 mixFragmentShader(VertexOut in [[stage_in]],
                                  texture2d<float, access::sample> color1Sampler [[texture(1)]],
                                  texture2d<float, access::sample> color2Sampler [[texture(2)]]) {
    
    float4 baseColor = color1Sampler.sample(s, in.texcoord);
    float4 outline = color2Sampler.sample(s, in.texcoord);

    float4 combined = baseColor * outline;
    
    return combined;
};


