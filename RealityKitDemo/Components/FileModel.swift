//
//  FileModelView.swift
//  RealityKitDemo
//
//  Created by JaedenXu on 2025/7/17.
//

import SwiftUI
import RealityKit

struct FileModel: View {
    // 添加一个状态变量来存储加载的模型实体
    @State private var modelEntity: Entity? = nil
    
    // 添加旋转状态变量
    @State private var rotationAngle: Float = 0.0
    @State private var lastDragValue: CGFloat = 0.0
    @State private var currentAngle: Float = 0.0
    
    // 加载模型的方法
    static func loadModel() -> Entity? {
        do {
            // 尝试加载USDZ模型
            let modelEntity = try Entity.load(named: "drummer")
            return modelEntity
        } catch {
            print("无法加载模型: \(error.localizedDescription)")
            return nil
        }
    }
    
    var body: some View {
        // 模型显示区域
        ZStack {
            RealityView { content in
                // 创建场景锚点
                let anchor = AnchorEntity()
                
                // 同步加载模型
                if let entity = FileModel.loadModel() {
                    // 设置模型名称
                    entity.name = "fileModel"
                    
                    // 调整模型位置和大小 - 缩小并居中
                    entity.position = [0, -0.5, 0]
                    entity.scale = [0.05, 0.05, 0.05]
                    
                    // 将模型添加到锚点
                    anchor.addChild(entity)
                    
                    // 更新状态变量
                    self.modelEntity = entity
                }
                
                // 将锚点添加到内容中
                content.add(anchor)
            } update: { content in
                // 更新模型旋转
                if let modelEntity = self.modelEntity {
                    // 应用当前旋转角度
                    modelEntity.transform.rotation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.all)
            
            // 添加手势识别器
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // 计算拖动距离并转换为旋转角度
                        let dragDelta = value.translation.width - lastDragValue
                        lastDragValue = value.translation.width
                        
                        // 调整旋转速度系数
                        let rotationFactor: Float = 0.01
                        
                        // 更新旋转角度
                        currentAngle += Float(dragDelta) * rotationFactor
                        rotationAngle = currentAngle
                    }
                    .onEnded { _ in
                        // 重置拖动值，保持当前角度
                        lastDragValue = 0
                    }
            )
        }
    }
}

#Preview {
    FileModel()
}