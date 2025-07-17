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
    
    var body: some View {
        // 模型显示区域
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
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .edgesIgnoringSafeArea(.all)
    }
}

// 添加静态方法用于加载模型
extension FileModel {
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
}

#Preview {
    FileModel()
}
