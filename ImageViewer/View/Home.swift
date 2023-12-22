//
//  Home.swift
//  ImageViewer
//
//  Created by kwon eunji on 12/22/23.
//

import SwiftUI

struct Home: View {
    @State private var posts:[Post] = samplePosts
   
    //View Properties
    @State private var showDetailView: Bool = false
    @State private var selectedPicID: UUID?
    @State private var selectedPost: Post?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 15) {
                    ForEach(posts) { post in
                        CardView(post)
                    }
                }
                .safeAreaPadding(15)
            }
            .navigationTitle("Animation")
        }
        .overlay {
            if let selectedPost, showDetailView {
                DetailView(showDetailView: $showDetailView,
                           post: selectedPost,
                           selectedPicId: $selectedPicID
                ) { id in
                    // updating Scroll Position
                    if let index = posts.firstIndex(where: { $0.id == selectedPost.id}) {
                        posts[index].scrollPosition = id
                    }
                }
                .transition(.offset(y: 5))
            }
        }
        .overlayPreferenceValue(OffsetKey.self, { value in
            GeometryReader { proxy in
                if let selectedPicID, let source = value[selectedPicID.uuidString],
                   let destination = value["DESTINATION\(selectedPicID.uuidString)"],
                   let picItem = selectedImage(),
                   showDetailView {
                    let sRect = proxy[source]
                    let dRect = proxy[destination]
                    
                    Image(picItem.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: sRect.width, height: sRect.height)
                        .clipShape(.rect(cornerRadius: 0))
                        .offset(x: sRect.minX, y: sRect.minY)
                }
            }
        })
    }
    
    func selectedImage() -> PicItem? {
        if let pic = selectedPost?.pics.first(where: { $0.id == selectedPicID}) {
            return pic
        }
        
        return nil
    }
    
    //Card View
    @ViewBuilder
    func CardView(_ post: Post) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.teal)
                    .frame(width: 30, height: 30)
                    .background(.background)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.username)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                    
                    Text(post.content)
                }
                
                Spacer(minLength: 0)
                
                Button("", systemImage: "ellipsis") {
                    //
                }
                .foregroundStyle(.primary)
                .offset(y: -10)
            }
            
            VStack(alignment: .leading, spacing: 10) {
            
            //Image Carousel Using New ScrollView(iOS 17+)
            GeometryReader {
                let size = $0.size
                
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(post.pics) { pic in
                            LazyHStack {
                                Image(pic.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: size.width)
                                    .clipShape(.rect(cornerRadius: 10))
                            }
                            .frame(maxWidth: size.width)
                            .frame(height: size.height)
                            .anchorPreference(key: OffsetKey.self, value: .bounds, 
                                transform: { anchor in
                                return [pic.id.uuidString: anchor]
                            })
                                .onTapGesture {
                                    selectedPost = post
                                    selectedPicID = pic.id
                                    showDetailView = true
                                }
                                .contentShape(.rect)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: .init(get: {
                    return post.scrollPosition
                }, set: { _ in
                    
                }))
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
                }
            .frame(height: 200)
                
                //Image Button
                HStack(spacing: 10) {
                    ImageButton("suit.heart") {
                        //
                    }
                    ImageButton("message") {
                        //
                    }
                    ImageButton("arrow.2.squarepath") {
                        //
                    }
                    ImageButton("paperplane") {
                        //
                    }
                }
                
            }
            .safeAreaPadding(.leading, 45)
            
            // Likes & Replies
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .frame(width: 30, height: 30)
                    .background(.background)
                
                Button("10 replies") {
                    
                }
                Button("810 likes") {
                    
                }
                .padding(.leading, -5)
                
                Spacer()
            }
            .textScale(.secondary)
            .foregroundStyle(.secondary)
        }
        .background(alignment: .leading) {
            Rectangle()
                .fill(.secondary)
                .frame(width: 1)
                .padding(.bottom, 30)
                .offset(x: 15, y: 10)
        }
    }
    
    
    @ViewBuilder
    func ImageButton(_ icon: String, onTap: @escaping () -> ()) -> some View {
        Button("", systemImage: icon, action: onTap)
            .font(.title3)
            .foregroundStyle(.primary)
    }
    
}

#Preview {
    ContentView()
}

struct DetailView: View {
    @Binding var showDetailView: Bool
    var post: Post
    @Binding var selectedPicId: UUID?
    // View {roperties
    @State private var detailScrollPosition: UUID?
    var updateScrollPosition: (UUID?) -> ()
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(post.pics) { pic in
                    Image(pic.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .containerRelativeFrame(.horizontal)
                        .clipped()
                        .anchorPreference(key: OffsetKey.self, value: .bounds,
                            transform: { anchor in
                            return ["DESTINATION\(pic.id.uuidString)": anchor]
                        })
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $detailScrollPosition)
        .background(.black)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        //Close Button
        .overlay(alignment: .topLeading) {
            Button("", systemImage: "xmark.circle.fill") {
                updateScrollPosition(detailScrollPosition)
                showDetailView = false
                selectedPicId = nil
            }
            .font(.title)
            .foregroundStyle(.white.opacity(0.8), .white.opacity(0.15))
            .padding()
        }
        .onAppear {
            guard detailScrollPosition == nil else { return }
            detailScrollPosition = selectedPicId
        }
    }
}
