//
//  ContentView.swift
//  RealityKitDemo
//
//  Created by JaedenXu on 2025/7/17.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    // 添加一个状态变量来控制旋转角度
    @State private var rotationAngle: Float = 0
    
    // 创建一个定时器来更新旋转角度
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        RealityView { content in
            
            // 创建一个立方体模型
            let model = Entity()
            let mesh = MeshResource.generateBox(size: 0.3, cornerRadius: 0.01)
            let material = SimpleMaterial(color: .blue, roughness: 0.15, isMetallic: true)
            model.components.set(ModelComponent(mesh: mesh, materials: [material]))
            
            // 将立方体放置在相机前方
            model.position = [0, 0, -0.5]
            
            // 旋转立方体使其看起来更加立体
            model.transform.rotation = simd_quatf(angle: Float.pi/6, axis: [1, 1, 0])
            
            // 为内容创建场景锚点
            let anchor = AnchorEntity()
            anchor.addChild(model)
            
            // 将锚点添加到场景中
            content.add(anchor)
            
            // 直接设置模型名称，不使用异步闭包
            model.name = "rotatingCube"
            
        } update: { content in
            // 在更新回调中旋转立方体
            if let cube = content.entities.first?.children.first(where: { $0.name == "rotatingCube" }) {
                cube.transform.rotation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.1))
        .cornerRadius(20)
        .edgesIgnoringSafeArea(.all)
        // 接收定时器事件并更新旋转角度
        .onReceive(timer) { _ in
            // 每次更新增加一小段角度，实现连续旋转效果
            rotationAngle += 0.01
            // 当角度超过2π时重置，避免数值过大
            if rotationAngle > Float.pi * 2 {
                rotationAngle = 0
            }
        }
    }

}

#Preview {
    ContentView()
}
