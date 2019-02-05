import MetalKit

struct Vertex{
    var position: float3
    var color: float4
    var textCoords: float2
    var normal: float3
}

struct ModelConstants{
    var modelViewMatrix = matrix_identity_float4x4
    var materialColor = float4(1)
    var normalMatrix = matrix_identity_float3x3
    var shininess: Float = 0.0
    var specularIntensity: Float = 0.0
}

struct SceneConstants{
    var projectionMatrix = matrix_identity_float4x4
}

struct Light{
    var color: float3 = float3(1)
    var ambientIntensity: Float = 0.0
    var direction = float3(0)
    var diffuseIntensity: Float = 0.2
    
}
struct moveData {
    static var camZ: Float = 0.0
    static var camX: Float = 0.0
    static var camY: Float = 0.0
    static var camRY: Float = 0.0
    static var camRX: Float = 0.0
}
struct SkyBoxConstants {
    static var modelViewMatrix = matrix_identity_float4x4
    static var modelViewProjectionMatrix = matrix_identity_float4x4
    static var normalMatrix = matrix_identity_float4x4
    static var invertedViewMatrix = matrix_identity_float4x4
    static var skyBoxModelViewProjectionMatrix = matrix_identity_float4x4
}

