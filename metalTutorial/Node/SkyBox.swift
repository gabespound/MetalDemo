import MetalKit
import Foundation

class SkyBox: Node{
    var texture: MTLTexture?
    
    static let cubeVData: [float4] = [
        // posx
        [-1.0,  1.0,  1.0, 1.0 ],
        [ -1.0, -1.0,  1.0, 1.0 ],
        [ -1.0,  1.0, -1.0, 1.0 ],
        [ -1.0, -1.0, -1.0, 1.0 ],
        
        // negz
        [ -1.0,  1.0, -1.0, 1.0 ],
        [ -1.0, -1.0, -1.0, 1.0 ],
        [ 1.0,  1.0, -1.0, 1.0 ],
        [ 1.0, -1.0, -1.0, 1.0 ],
        
        // negx
        [ 1.0,  1.0, -1.0, 1.0 ],
        [ 1.0, -1.0, -1.0, 1.0 ],
        [ 1.0,  1.0,  1.0, 1.0 ],
        [ 1.0, -1.0,  1.0, 1.0 ],
        
        // posz
        [ 1.0,  1.0,  1.0, 1.0 ],
        [ 1.0, -1.0,  1.0, 1.0 ],
        [ -1.0,  1.0,  1.0, 1.0 ],
        [ -1.0, -1.0,  1.0, 1.0 ],
        
        // posy
        [ 1.0,  1.0, -1.0, 1.0 ],
        [ 1.0,  1.0,  1.0, 1.0 ],
        [ -1.0,  1.0, -1.0, 1.0 ],
        [ -1.0,  1.0,  1.0, 1.0 ],
        
        // negy
        [ 1.0, -1.0,  1.0, 1.0 ],
        [ 1.0, -1.0, -1.0, 1.0 ],
        [ -1.0, -1.0,  1.0, 1.0 ],
        [ -1.0, -1.0, -1.0, 1.0 ],
    ]
    
    var renderPipelineState: MTLRenderPipelineState!
    var vertexDescriptor: MTLVertexDescriptor{
        let vertexDescriptor = MTLVertexDescriptor()
        //pos
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].format = .float4
        vertexDescriptor.attributes[0].offset = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.size * 4
        
        return vertexDescriptor
    }
    var skyBoxBuffer: MTLBuffer!
    
    var vertexFunctionName = "skyboxVertex"
    var fragmentFunctionName = "skyboxFragment"
    
    var vertexBuffer: MTLBuffer!
    
    init(device: MTLDevice) {
        super.init()
        if let texture = setTexture(device: device, imageName: "skybox.png"){
            self.texture = texture
        }
        buildBuffers(device: device)
        renderPipelineState = buildPipelineState(device: device)
        
    }
    
    func buildBuffers(device: MTLDevice){
        vertexBuffer = device.makeBuffer(bytes: SkyBox.cubeVData, length: SkyBox.cubeVData.count * MemoryLayout<float4>.size, options: [])
        skyBoxBuffer = device.makeBuffer(length: MemoryLayout<matrix_float4x4>.size, options: [])
    }
    
    func rotate(angle: Float, r: float3) -> float4x4{
        let a = angle * 1.0/180.0
        let c = cos(a)
        let s = sin(a)
        
        let k = 1.0 - c
        let u = normalize(r)
        let v = s * u
        let w = k * u
        
        let P = float4([w.x * u.x + c, w.x * u.y + v.z, w.x * u.z - v.y, 0.0])
        let Q = float4([w.x * u.y - v.z, w.y * u.y + c, w.y * u.z + v.x, 0.0])
        let R = float4([w.x * u.z + v.y, w.y * u.z - v.x, w.z * u.z + c, 0.0])
        let S = float4([0.0, 0.0, 0.0, 1.0])
        
        return float4x4(rows: [P, Q, R, S])
        
    }
    
}

extension SkyBox: Renderable{
    
    func draw(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        commandEncoder.setRenderPipelineState(renderPipelineState)
        
        SkyBoxConstants.modelViewMatrix = float4x4(columns: (float4(10.0), float4(10.0), float4(10.0), float4(10.0))) * rotate(angle: 1/60, r: [0.0, 1.0, 0.0])
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 1)
        commandEncoder.setVertexBytes(&SkyBoxConstants.modelViewMatrix, length: MemoryLayout<matrix_float4x4>.stride, index: 2)
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 24)
    }
}

extension SkyBox: Texturable{
    
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        return texture
    }
}
