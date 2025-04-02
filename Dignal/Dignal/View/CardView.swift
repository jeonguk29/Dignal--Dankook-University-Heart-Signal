//
//  CardView.swift
//  MulMulMarket
//
//  Created by 정정욱 on 6/23/24.
//

import SwiftUI

struct CardView: View, Identifiable {
    let id = UUID()
    var imageName: String
    var question: String
    var answer: String

    var body: some View {
        Image(imageName)
            .resizable()
            .cornerRadius(24)
            .scaledToFit()
            .frame(minWidth: 0, maxWidth: .infinity)
            .overlay(
                VStack(alignment: .center, spacing: 12) {
                    Text(question)
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .shadow(radius: 1)
                        .padding(.horizontal, 18)

                    Text(answer)
                        .foregroundColor(Color.black)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(minWidth: 85)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color.white)
                        )
                }
                .frame(minWidth: 280)
                .padding(.bottom, 50),
                alignment: .bottom
            )
    }
}


// ✅ 프리뷰
#Preview {
    CardView(
        imageName: "photo-athens-greece",
        question: "상대방 이름은?",
        answer: "정정욱"
    )
    .previewLayout(.fixed(width: 375, height: 600))
}
