import MetalKit

class BasicScene: Scene{
    
    var speed: Float = 0.5
    
    var model: Model!
    override init(device: MTLDevice){
        model = Model(device: device, modelName: "armadillo", imageName: "")
        super.init(device: device)

        model.position.z = -4
        model.position.y = -0.5
        
        model.materialColor = float4(0.5, 0.6, 0.6, 1.0)
        light.color = float3(1)
        light.direction = float3(0,0,-1)
        
        add(child: model)

    }
    
    override func updateModel() {
        model.shininess = Preferences.shine
        model.specularIntensity = Preferences.spec
        model.scale = float3(1)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float){
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
    }
    
    override func updateInput(deltaTime: Float) {
        //Model
        model.rotation.y += moveData.camRY
        model.rotation.x += moveData.camRX
        moveData.camRX = 0.0
        moveData.camRY = 0.0

        //Camera
        camera.position.z += moveData.camZ
        moveData.camZ = 0.0
        camera.position.x += moveData.camX
        moveData.camX = 0
        camera.position.y -= moveData.camY
        moveData.camY = 0
    }
    
}
