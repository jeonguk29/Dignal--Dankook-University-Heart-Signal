//
//  MatchingView.swift
//  Dignal
//
//  Created by 정정욱 on 3/29/25.
//

import SwiftUI

struct MatchingView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.coralPink.ignoresSafeArea()

            VStack(spacing: 30) {
                // 곰돌이 이미지
                Image("matchingLogo") // 단웅이 이미지
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .animation(
                        .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                // 텍스트
                Text("상대방을 찾고 있어요...")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)

                // 로딩 점 애니메이션 (Dot Animation)
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(Color.darkCoral)
                            .frame(width: 10, height: 10)
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .animation(
                                .easeInOut(duration: 0.6).repeatForever().delay(Double(i) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.top, 10)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    MatchingView()
}
