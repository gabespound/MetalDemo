import MetalKit

class Renderer: NSObject{
    
    var commandQueue: MTLCommandQueue!
    
    var depthStencilState: MTLDepthStencilState!
    
    var samplerState: MTLSamplerState!
    
    var scene: Scene!
    
    var device: MTLDevice!
    
    var modelScene: Bool = true
    
    static var sceneChanged: Bool = true
    
    var wireFrameOn:Bool = false
    
    init(device: MTLDevice){
        super.init()
        self.device = device
        changeScene(device: device)
        commandQueue = device.makeCommandQueue()
        changeScene(device: device)
        buildDepthStencilState(device: device)
        buildSamplerState(device: device)
    }
    
    func buildDepthStencilState(device: MTLDevice){
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
    func buildSamplerState(device: MTLDevice){
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: samplerDescriptor)!
        
    }
    
    func changeScene(device: MTLDevice){
        if Renderer.sceneChanged {
            if(self.modelScene){
                self.scene = BasicScene(device: device)
                self.modelScene = false
            } else{
                self.scene = TerrainScene(device: device)
                self.modelScene = true
            }
            Renderer.sceneChanged = false
        }
    }
    
}
extension Renderer: MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.camera.aspectRatio = Float(Float(view.bounds.width)/Float(view.bounds.height))
    }
    
    func draw(in view: MTKView) {
        changeScene(device: self.device)
        scene.camera.aspectRatio = Float(Float(view.bounds.width)/Float(view.bounds.height))
        guard let drawable = view.currentDrawable,
            let renderPassDescriptor = view.currentRenderPassDescriptor else {return}
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.setDepthStencilState(depthStencilState)
        commandEncoder?.setFragmentSamplerState(samplerState, index: 0)
        
        if(Preferences.useWireFrame){
            commandEncoder?.setTriangleFillMode(.lines)
        } else {
            commandEncoder?.setTriangleFillMode(.fill)
        }
        
        //scene.light.lightPos = MetalView.tapLoc
        
        let deltaTime = 1/Float(view.preferredFramesPerSecond)
        
        scene.render(commandEncoder: commandEncoder!, deltaTime: deltaTime)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
