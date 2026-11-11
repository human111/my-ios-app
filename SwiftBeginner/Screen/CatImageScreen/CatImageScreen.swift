//
//  CatImageScreen.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/11.
//

import SwiftUI

struct CatImageScreen: View {
    @EnvironmentObject private var apiManager: CatAPIManager
    
    @State private var catImages: [CatImageViewModel] = []
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            HStack {
                Text("可愛貓咪")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("換一批", action: loadRandomImages)
                    .buttonStyle(.bordered)
                    .font(.headline)
                    .overlay {
                        if isLoading {
                            ProgressView()
                        }
                    }
                    .disabled(isLoading)
                
            }.padding(.horizontal)
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(catImages) { catImage in
                        let isFavourited = apiManager.favorites.contains(where: \.imageID == catImage.id)
                        CatImageView(catImage, isFavourited: isFavourited) {
                            await toggleFavorite(catImage)
                        }.id(catImage.id)
                    }
                }.onChange(of: catImages.first?.id) { newID in
                    guard let newID else { return }
                    withAnimation {
                        proxy.scrollTo(newID)
                    }
                }
            }
        }
        .alert(errorMessage: $errorMessage)
        .onAppear {
            if !catImages.isEmpty && !isLoading { return }
            loadRandomImages()
        }
    }
}

private extension CatImageScreen {
    func loadRandomImages() {
        Task {
            do {
                isLoading = true
                catImages = (try await apiManager.getImages()).map(CatImageViewModel.init)
            } catch {
                errorMessage = "無法載入圖片資訊"
            }
            isLoading = false
        }
    }
    
    func toggleFavorite(_ cat: CatImageViewModel) async {
        do {
            try await apiManager.toggleFavorite(cat)
        } catch {
            errorMessage = "無法更新最愛"
        }
    }
}

#Preview {
    CatImageScreen()
}
