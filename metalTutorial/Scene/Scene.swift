import MetalKit

class Scene: Node{
    
    var device: MTLDevice!
    var sceneConstants = SceneConstants()
    
    var camera = Camera()
    
    var light = Light()
    
    init(device: MTLDevice){
        self.device = device
        super.init()

    }
    
    func updateInput(deltaTime: Float) {}
    
    func updateModel() {}
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float){
        light.ambientIntensity = Preferences.ambient
        light.diffuseIntensity = Preferences.diffuse
        updateInput(deltaTime: deltaTime)
        updateModel()
        
        sceneConstants.projectionMatrix = camera.projectionMatrix
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 2)
        commandEncoder.setFragmentBytes(&light, length: MemoryLayout<Light>.stride, index: 1)
        //commandEncoder.setFragmentBytes(&texture, length: MemoryLayout<Texture>, index: 2)
        
        for child in children{
            child.render(commandEncoder: commandEncoder, parentModelMatrix: camera.viewMatrix)
        }
        
    }
    
}
