//
//  LoginView.swift
//  Dignal
//
//  Created by 정정욱 on 3/29/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            // 앱 타이틀
            Text("Dignal")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 120)
            
            Text("단국대 2025년 축제 경영공학과와 함께")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 10)
            
            // 로고 이미지
            Image("mainLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding(.top, 20)


            // Apple 로그인 버튼
            SignInWithAppleButton(
                onRequest: { request in
                    // 요청 설정
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        print("Apple 로그인 성공: \(authResults)")
                    case .failure(let error):
                        print("Apple 로그인 실패: \(error.localizedDescription)")
                    }
                }
            )
            .signInWithAppleButtonStyle(.white)
            .frame(height: 50)
            .padding(.horizontal, 40)
            .padding(.top, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("mainColor")) // 필요 시 배경 컬러 추가
    }
}

#Preview {
    LoginView()
}
