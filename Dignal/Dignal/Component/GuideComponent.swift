//
//  GuideComponent.swift
//  MulMulMarket
//
//  Created by 정정욱 on 6/23/24.
//

import SwiftUI

struct GuideComponent: View {
    
    var title: String
    var subtitle: String
    var description: String
    var icon: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: icon)
                .font(.largeTitle) // 이걸로 이미지 크기 설정이 가능함
                .foregroundColor(Color.pink)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title.uppercased())
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()
                    Text(subtitle.uppercased())
                        .font(.footnote)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.pink)
                }
                
                Divider().padding(.bottom, 4)
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true) // 이 수정자는 뷰의 크기를 고정하여 부모 뷰의 크기 변화에 영향을 받지 않게 하거나, 자식 뷰의 콘텐츠 크기에 따라 크기를 조정하게 만듭니다.
            }
        }
    }
}

struct GuideComponent_Previews: PreviewProvider {
    static var previews: some View {
        GuideComponent(title: "Title", subtitle: "Swipe right", description: "This is a placeholder sentence This is a placeholder sentence", icon: "heart.circle")
            .previewLayout(.sizeThatFits)
    }
}
