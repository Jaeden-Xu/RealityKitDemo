//
//  ContentView.swift
//  RealityKitDemo
//
//  Created by JaedenXu on 2025/7/17.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.1))
        .cornerRadius(20)
        .edgesIgnoringSafeArea(.all)
    }

}

#Preview {
    ContentView()
}
