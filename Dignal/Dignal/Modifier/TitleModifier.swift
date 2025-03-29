//
//  SwiftUIView.swift
//  MulMulMarket
//
//  Created by 정정욱 on 6/24/24.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(Color.pink)
    }
}

