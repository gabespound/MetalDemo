import MetalKit

class TerrainScene: Scene{
    
    var speed: Float = 0.1
    var t: Terrain!
    override init(device: MTLDevice){
        super.init(device: device)
        t = Terrain(device: device, imageName: "Grass.jpg")
        model = Model(device: device, modelURL: Bundle.main.url(forResource: "f16", withExtension: ".obj")!, imageName: "F16s.bmp")
        
        model.position.z = -4
        model.position.y = 20
        model.scale.x = 30
        model.scale.y = 30
        model.scale.z = 30
        t.position.x = -400
        t.position.z = -400
        
        model.materialColor = float4(0.5, 0.6, 0.6, 1.0)
        light.color = float3(1)
        light.direction = float3(0,0,-1)
        
        camera.farZ = -1000
        
        self.rotation.x = 10
        
        
        add(child: t)
        add(child: model)
    }
    
    override func updateModel() {
        model.shininess = Preferences.shine
        model.specularIntensity = Preferences.spec
        model.scale = float3(30)
    }
    
    func newModel() {
        children.removeAll()
        model.materialColor = float4(0.5, 0.6, 0.6, 1.0)
        model.position.z = -4
        model.position.y = 20
        model.scale.x = 30
        model.scale.y = 30
        model.scale.z = 30
        t.position.x = -400
        t.position.z = -400
        add(child: model)
        add(child: t)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float){
        light.ambientIntensity = 1
        light.diffuseIntensity = 1
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
    
    override func updateInput(deltaTime: Float) {

        //Camera
        camera.position.z += moveData.camZ * 50
        moveData.camZ = 0.0
        camera.position.x += moveData.camX * 50
        moveData.camX = 0
        camera.position.y -= moveData.camY * 50
        moveData.camY = 0
        camera.rotation.y += moveData.camRY/5
        camera.rotation.x += moveData.camRX/5
        moveData.camRX = 0.0
        moveData.camRY = 0.0
    }
    
}
