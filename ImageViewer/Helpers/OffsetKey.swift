//
//  OffsetKey.swift
//  ImageViewer
//
//  Created by kwon eunji on 12/22/23.
//

import SwiftUI

// Anchor Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}


