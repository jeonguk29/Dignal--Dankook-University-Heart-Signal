//
//  CardTransition.swift
//  MulMulMarket
//
//  Created by 정정욱 on 6/25/24.
//


import SwiftUI

// AnyTransition 타입에 두 가지 새로운 전환을 추가하여 뷰가 화면에서 사라질 때의 애니메이션을 지정
extension AnyTransition {
    
    static var trailingBottom: AnyTransition {
        AnyTransition.asymmetric(insertion: .identity, removal: AnyTransition.move(edge: .trailing).combined(with: .move(edge: .bottom)))
    }
    
    static var leadingBottom: AnyTransition {
        AnyTransition.asymmetric(insertion: .identity, removal: AnyTransition.move(edge: .leading).combined(with: .move(edge: .bottom)))
    }
}
