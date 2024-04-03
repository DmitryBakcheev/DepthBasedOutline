//
//  MyTechnique.swift
//  DepthBasedOutline
//
//  Created by Dmitry Bakcheev on 4/3/24.
//


import Foundation


enum MyTechnique {
    static let techniqueDictionary: [String: Any] = [
        
        
        
        "symbols": [
            "size_symbols": ["type": "vec4"],
            "scale_symbols": ["type": "float"]
        ],
        
        "passes": [
            
            "first_pass": [
                "draw": "DRAW_SCENE",
                "inputs": [
                ],
                "outputs": [
                    "color": "color_scene"
                ],
                "colorStates": [
                    "clear": true,
                    "clearColor": "sceneBackground"
                ]
            ],
            
            
            "depth_pass": [
                
                "draw": "DRAW_QUAD",
                "metalVertexShader": "myVertexShader",
                "metalFragmentShader": "myFragmentShader",
                
                "inputs": [
                    "color": "COLOR",
                    "depth": "DEPTH",
                    "size": "size_symbols",
                    "scale": "scale_symbols"
                ],
                "outputs": [
                    "color":  "depth_scene",
                ]
            ],
            
            "mix_pass": [
                "draw": "DRAW_QUAD",
                
                "metalVertexShader": "myVertexShader",
                "metalFragmentShader": "mixFragmentShader",
                
                "inputs": [
                    "color1Sampler": "color_scene",
                    "color2Sampler": "depth_scene",
                ],
                "outputs": [
                    "color": "COLOR"
                ]
            ]
        ],
        
        "sequence": [
            "first_pass",
            "depth_pass",
            "mix_pass"
        ],
        
        
        "targets": [
            "color_scene": [
                "type": "color"
            ],
            "depth_scene": [
                "type": "color"
            ]
        ]
    ]
    
}
