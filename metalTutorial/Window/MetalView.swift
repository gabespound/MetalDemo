//
//  MetalView.swift
//  metalTutorial
//
//  Created by Gabriel Spound on 5/6/18.
//  Copyright © 2018 Gabriel Spound. All rights reserved.
//

import Foundation
import MetalKit

class MetalView: MTKView {
    
    var renderer: Renderer!
    static var tapLoc: float2 = float2(0)
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        self.colorPixelFormat = .bgra8Unorm
        
        self.depthStencilPixelFormat  = .depth32Float
        
        self.clearColor = MTLClearColor(red: 1, green: 1, blue: 0, alpha: 1)
        
        renderer = Renderer(device: device!)
        
        self.delegate = renderer
        self.delegate?.mtkView(self, drawableSizeWillChange: self.drawableSize)
        
    }
    
    func toggleWireFrame(){
            Preferences.useWireFrame = !Preferences.useWireFrame
    }
}
