import MetalKit

class Instance: Node{
    
    var model: Model!
    
    var vertexFunctionName: String = "instance_vertex_function"
    var fragmentFunctionName: String = "basic_fragment_function"
    
    var renderPipelineState: MTLRenderPipelineState!
    var vertexDescriptor: MTLVertexDescriptor
    
    var nodes = [Node]()
    var instances = [ModelConstants]()
    
    var instanceBuffer: MTLBuffer!
    
    init(device: MTLDevice, modelName: String, imageName: String, instanceCount: Int){
        model = Model(device: device, modelName: modelName, imageName: imageName)
        vertexDescriptor = model.vertexDescriptor
        super.init()
        generate(instanceCount: instanceCount)
        createBuffer(device: device)
        renderPipelineState = buildPipelineState(device: device)
    }
    
    func generate(instanceCount: Int){
        for _ in 0..<instanceCount{
            let node = Node()
            nodes.append(node)
            instances.append(ModelConstants())
        }
    }
    
    func createBuffer(device: MTLDevice){
        instanceBuffer = device.makeBuffer(length: MemoryLayout<ModelConstants>.stride * nodes.count, options: [])
        
    }
    
}

extension Instance: Renderable{
    
        func draw(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let instanceBuffer = self.instanceBuffer, nodes.count > 0 else {return}
            commandEncoder.setRenderPipelineState(renderPipelineState)
        var pointer = instanceBuffer.contents().bindMemory(to: ModelConstants.self, capacity: nodes.count)
        
        for node in nodes{
            pointer.pointee.modelViewMatrix = matrix_multiply(modelViewMatrix, node.modelMatrix)
            pointer.pointee.materialColor = node.materialColor
            pointer = pointer.advanced(by: 1)
        }
        commandEncoder.setVertexBuffer(instanceBuffer, offset: 0, index: 1)
        
        guard let meshes = model.meshes.metalKitMeshes as? [MTKMesh], meshes.count > 0 else {return}
        for mesh in meshes{
            let vertexBuffer = mesh.vertexBuffers[0]
            commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
            
            for submesh in mesh.submeshes{
                commandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                     indexCount: submesh.indexCount,
                                                     indexType: submesh.indexType,
                                                     indexBuffer: submesh.indexBuffer.buffer,
                                                     indexBufferOffset: submesh.indexBuffer.offset,
                                                     instanceCount: nodes.count)
            }
        }
    }
}
