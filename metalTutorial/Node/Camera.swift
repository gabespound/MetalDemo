import MetalKit

class Camera: Node{
    
    var aspectRatio: Float = 1
    var fov: Float = 45
    var nearZ: Float = 0.1
    var farZ: Float = 100
    
    var viewMatrix: matrix_float4x4{
        return modelMatrix
    }
    
    var projectionMatrix:matrix_float4x4 {
        return matrix_float4x4(degreesFov: fov, aR: aspectRatio, nearZ: nearZ, farZ: farZ)
    }
}
