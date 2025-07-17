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
    // body计算属性，定义视图的内容和布局
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("模型展示")) {
                    NavigationLink(destination: BasicModel()) {
                        HStack {
                            Image(systemName: "cube.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text("基础模型")
                                .font(.headline)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // 这里可以添加更多的模型选项
                    NavigationLink(destination: Text("高级模型内容将在这里显示")) {
                        HStack {
                            Image(systemName: "cube.transparent.fill")
                                .foregroundColor(.purple)
                                .font(.title2)
                            Text("高级模型")
                                .font(.headline)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("工具")) {
                    NavigationLink(destination: Text("设置页面将在这里显示")) {
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(.gray)
                                .font(.title2)
                            Text("设置")
                                .font(.headline)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    NavigationLink(destination: Text("关于页面将在这里显示")) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.gray)
                                .font(.title2)
                            Text("关于")
                                .font(.headline)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("RealityKit演示")
            
            // 默认显示的欢迎页面
            Text("请从左侧列表选择一个选项")
                .font(.title)
                .foregroundColor(.secondary)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

// SwiftUI预览提供程序，用于在Xcode中预览ContentView
#Preview {
    ContentView()
}