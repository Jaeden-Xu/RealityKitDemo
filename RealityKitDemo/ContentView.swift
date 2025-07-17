// 文件头部注释
//  ContentView.swift
//  RealityKitDemo
//
//  Created by JaedenXu on 2025/7/17.
//

// 导入SwiftUI框架，提供UI组件和布局功能
import SwiftUI
// 导入RealityKit框架，提供AR/3D渲染功能
import RealityKit

// ContentView结构体定义，遵循View协议
struct ContentView : View {
    
    // 添加一个状态变量来控制旋转角度，使用@State属性包装器使其可变
    @State private var rotationAngle: Float = 0
    
    // 添加一个状态变量来控制三棱锥的缩放比例，初始值为1.0（原始大小）
    @State private var pyramidScale: Float = 1.0
    
    // 添加一个变量来控制缩放方向（放大或缩小），初始为true表示正在放大
    @State private var scaleIncreasing: Bool = true
    
    // 创建一个定时器来更新旋转角度和缩放比例，每0.01秒触发一次，在主线程上运行
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    // body计算属性，定义视图的内容和布局
    var body: some View {
        // RealityView是RealityKit提供的视图，用于显示3D内容
        RealityView { content in
            
            // 创建一个立方体模型实体
            let cubeModel = Entity()
            // 生成一个边长为0.3，圆角半径为0.01的立方体网格
            let cubeMesh = MeshResource.generateBox(size: 0.3, cornerRadius: 0.01)
            // 创建绿色金属材质，粗糙度为0.05（较光滑）
            let greenMetalMaterial = SimpleMaterial(color: .green, roughness: 0.05, isMetallic: true)
            // 将网格和材质设置到立方体实体上
            cubeModel.components.set(ModelComponent(mesh: cubeMesh, materials: [greenMetalMaterial]))
            
            // 将立方体放置在相机前方的顶部位置，坐标为[x=0, y=0.8, z=-0.5]
            cubeModel.position = [0, 0.8, -0.5]
            
            // 旋转立方体使其看起来更加立体，绕[1,1,0]轴旋转π/6弧度（30度）
            cubeModel.transform.rotation = simd_quatf(angle: Float.pi/6, axis: [1, 1, 0])
            
            // 设置立方体模型的名称为"rotatingCube"，便于后续引用
            cubeModel.name = "rotatingCube"
            
            // 创建一个圆柱体模型实体
            let cylinderModel = Entity()
            // 生成一个高度为0.4，半径为0.1的圆柱体网格
            let cylinderMesh = MeshResource.generateCylinder(height: 0.4, radius: 0.1)
            // 创建半透明紫色玻璃材质，透明度为0.7，粗糙度为0.1（较光滑）
            let purpleGlassMaterial = SimpleMaterial(color: .purple.withAlphaComponent(0.7), roughness: 0.1, isMetallic: false)
            // 将网格和材质设置到圆柱体实体上
            cylinderModel.components.set(ModelComponent(mesh: cylinderMesh, materials: [purpleGlassMaterial]))
            
            // 将圆柱体放置在相机前方的中间位置，坐标为[x=0, y=0, z=-0.5]
            cylinderModel.position = [0, 0, -0.5]
            
            // 稍微旋转圆柱体，绕[1,0,1]轴旋转π/8弧度（约22.5度）
            cylinderModel.transform.rotation = simd_quatf(angle: Float.pi/8, axis: [1, 0, 1])
            
            // 设置圆柱体名称为"redCylinder"，便于后续引用
            cylinderModel.name = "redCylinder"
            
            // 创建一个三棱锥模型实体
            let pyramidModel = Entity()
            // 使用generateCone来创建三棱锥形状，高度为0.3，底部半径为0.15
            let pyramidMesh = MeshResource.generateCone(height: 0.3, radius: 0.15)
            // 创建橙色磨砂材质，粗糙度为0.8（非常粗糙），非金属质感
            let matteMaterial = SimpleMaterial(color: .orange, roughness: 0.8, isMetallic: false)
            // 将网格和材质设置到三棱锥实体上
            pyramidModel.components.set(ModelComponent(mesh: pyramidMesh, materials: [matteMaterial]))
            
            // 将三棱锥放置在相机前方的底部位置，坐标为[x=0, y=-0.8, z=-0.5]
            pyramidModel.position = [0, -0.8, -0.5]
            
            // 旋转三棱锥使其尖端朝上，角度为0表示不旋转
            pyramidModel.transform.rotation = simd_quatf(angle: 0, axis: [0, 0, 1])
            
            // 设置三棱锥名称为"yellowPyramid"，便于后续引用
            pyramidModel.name = "yellowPyramid"
            
            // 为内容创建场景锚点，用于将3D对象固定在空间中
            let anchor = AnchorEntity()
            // 将立方体添加为锚点的子对象
            anchor.addChild(cubeModel)
            // 将圆柱体添加为锚点的子对象
            anchor.addChild(cylinderModel)
            // 将三棱锥添加为锚点的子对象
            anchor.addChild(pyramidModel)
            
            // 将锚点添加到RealityKit内容中，使所有3D对象可见
            content.add(anchor)
            
        } update: { content in
            // 在更新回调中旋转立方体，每次定时器触发时执行
            if let cube = content.entities.first?.children.first(where: { $0.name == "rotatingCube" }) {
                // 根据当前rotationAngle值绕Y轴旋转立方体
                cube.transform.rotation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])
            }
            
            // 在更新回调中旋转圆柱体，使用不同的旋转轴（X轴）
            if let cylinder = content.entities.first?.children.first(where: { $0.name == "redCylinder" }) {
                // 根据当前rotationAngle值绕X轴旋转圆柱体
                cylinder.transform.rotation = simd_quatf(angle: rotationAngle, axis: [1, 0, 0])
            }
            
            // 在更新回调中只应用三棱锥的缩放效果
            if let pyramid = content.entities.first?.children.first(where: { $0.name == "yellowPyramid" }) {
                // 应用当前的缩放比例到三棱锥的所有三个轴向
                pyramid.transform.scale = SIMD3<Float>(pyramidScale, pyramidScale, pyramidScale)
                // 保持固定旋转角度，不随时间变化，确保尖端朝上
                pyramid.transform.rotation = simd_quatf(angle: 0, axis: [0, 0, 1])
            }
        }
        // 设置RealityView的框架尺寸为最大宽度和高度，填满可用空间
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // 添加半透明黑色背景，透明度为0.1
        .background(Color.black.opacity(0.1))
        // 添加20点的圆角效果
        .cornerRadius(20)
        // 忽略安全区域，使视图扩展到屏幕边缘
        .edgesIgnoringSafeArea(.all)
        // 接收定时器事件并更新旋转角度和缩放比例
        .onReceive(timer) { _ in
            // 每次更新增加一小段角度（0.01弧度），实现连续旋转效果
            rotationAngle += 0.01
            // 当角度超过2π（一整圈）时重置为0，避免数值过大
            if rotationAngle > Float.pi * 2 {
                rotationAngle = 0
            }
            
            // 更新三棱锥的缩放比例，实现呼吸效果
            if scaleIncreasing {
                // 放大模式：每次增加0.005的比例
                pyramidScale += 0.005
                // 当达到最大缩放比例1.3（原始大小的130%）时，改变方向开始缩小
                if pyramidScale >= 1.3 {
                    scaleIncreasing = false
                }
            } else {
                // 缩小模式：每次减少0.005的比例
                pyramidScale -= 0.005
                // 当达到最小缩放比例0.7（原始大小的70%）时，改变方向开始放大
                if pyramidScale <= 0.7 {
                    scaleIncreasing = true
                }
            }
        }
    }

}

// SwiftUI预览提供程序，用于在Xcode中预览ContentView
#Preview {
    ContentView()
}
