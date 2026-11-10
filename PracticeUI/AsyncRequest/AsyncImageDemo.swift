//
//  AsyncImageDemo.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/9.
//

import SwiftUI

extension URLSession {
    static let imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = .imageCache
        
        return .init(configuration: config)
    }()
}

extension URLCache {
    static let imageCache: URLCache = {
        .init(memoryCapacity: 20 * 1024 * 1024,
              diskCapacity: 30 * 1024 * 1024)
    }()
}

struct MyAsyncImage: View {
    @State private var phase: AsyncImagePhase
    let urlRequest: URLRequest
    var session: URLSession = .imageSession
    
    init(url: URL, session: URLSession = .imageSession) {
        self.session = session
        self.urlRequest = URLRequest(url: url)
        
        if let data = session.configuration.urlCache?.cachedResponse(for: urlRequest)?.data,
           let uiImage = UIImage(data: data) {
            _phase = .init(wrappedValue: .success(.init(uiImage: uiImage)))
        } else {
            _phase = .init(wrappedValue: .empty)
        }
    }
    
    var body: some View {
        Group {
            switch phase {
                case .empty:
                    ProgressView()
                        .scaleEffect(3)
                        .task {
                            await load()
                        }
                case .success(let image):
                    image.resizable().scaledToFit()
                case .failure:
                    Text("圖片無法顯示")
                @unknown default:
                    fatalError("This has not been implemented.")
            }
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
    
    func load() async {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse,
                    200...299 ~= response.statusCode,
                  let uiImage = UIImage(data: data)
            else {
                throw URLError(.unknown)
            }
            phase = .success(.init(uiImage: uiImage))
        } catch {
            phase = .failure(error)
        }
    }
}

struct AsyncImageDemo: View {
    @State private var id: UUID = UUID()
    // http://localhost:3000/images/1.jpg
    // https://images.unsplash.com/photo-1678880032033-d954b408963c?w=500
    let url = URL(string: "http://localhost:3000/images/5.jpg")!
    
    var body: some View {
        VStack {
            titleView
            // 方式一
//            AsyncImage(url: url) { image in
//                image.resizable().scaledToFit()
//            } placeholder: {
//                // 加载图片钱显示的loading视图，指定加载3s
//                ProgressView().scaleEffect(3)
//            }
            // 方式二
//            AsyncImage(url: url) { phase in
//                switch phase {
//                    case .empty:
//                        ProgressView().scaleEffect(3)
//                    case .success(let image):
//                        image.resizable().scaledToFit()
//                    case .failure(let error):
//                        Text(error.localizedDescription)
//                    @unknown default:
//                        fatalError("This has not been implemented")
//                }
//            }.id(id)
            
            // 方式三 封装加上缓存
            MyAsyncImage(url: url).id(id).frame(width: 360)
            
            Button("重新整理") {
                // 通过点击按钮替换id，让图片强制重新加载
                id = UUID()
            }
        }
    }
}

extension AsyncImageDemo {
    var titleView: some View {
        Text("AsyncImage Demo")
            .font(.largeTitle.bold())
    }
}

#Preview {
    AsyncImageDemo()
}
