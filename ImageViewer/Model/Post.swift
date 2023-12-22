//
//  Post.swift
//  ImageViewer
//
//  Created by kwon eunji on 12/22/23.
//

import SwiftUI

struct Post: Identifiable {
    let id: UUID = .init()
    var username: String
    var content: String
    var pics: [PicItem]
    //View Based Properties
    var scrollPosition: UUID?
}

// Sample Posts
var samplePosts: [Post] = [
    .init(username: "iJustine", content: "Nature Pics", pics: pics),
    .init(username: "iJustine", content: "Nature Pics", pics: pics.reversed())
]



// Constructing Pic Using Asset Image
private var pics: [PicItem] = (1...6).compactMap { index -> PicItem? in
    return .init(image: "pic \(index)")
}
