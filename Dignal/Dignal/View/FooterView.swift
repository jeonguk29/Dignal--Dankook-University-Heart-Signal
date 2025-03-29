//
//  FooterView.swift
//  MulMulMarket
//
//  Created by 정정욱 on 6/23/24.
//

import SwiftUI

struct FooterView: View {
    
    @Binding var showBookingAlert: Bool
    let haptics = UINotificationFeedbackGenerator() // 이 클래스는 iOS 기기에서 햅틱 피드백(진동)을 생성하는 역할
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.circle")
                .font(.system(size: 42, weight: .light))
            Spacer()
            
            Button {
                // Action
                playSound(sound: "sound-click", type: "mp3") // 사운드를 재생
                self.haptics.notificationOccurred(.success) // 진동을 발생 
                self.showBookingAlert.toggle()
            } label: {
                Text("Book Destination".uppercased())
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.heavy)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .accentColor(Color.pink)
                    .background {
                        Capsule().stroke(Color.pink, lineWidth: 2)
                    }
            }
            
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 42, weight: .light))
        }
        .padding()
    }
}

struct FooterView_Previews: PreviewProvider {
    @State static var showAlert: Bool = false
    
    static var previews: some View {
        FooterView(showBookingAlert: $showAlert)
            .previewLayout(.fixed(width: 375, height: 80))
    }
}
