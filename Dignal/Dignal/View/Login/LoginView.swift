//
//  LoginView.swift
//  Dignal
//
//  Created by 정정욱 on 3/29/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct LoginView: View {
    
    @EnvironmentObject var appState: AppState  // ✅ 전역 상태
    @StateObject private var viewModel = LoginViewModel()
    
    
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
                    request.requestedScopes = [.fullName, .email]
                    viewModel.currentNonce = randomNonceString()
                    request.nonce = sha256(viewModel.currentNonce!)
                },
                onCompletion: { result in
                    viewModel.appState = appState  // 주입
                    viewModel.handleAppleLogin(result: result)
                }
            )
            .signInWithAppleButtonStyle(.white)
            .frame(height: 50)
            .padding(.horizontal, 40)
            .signInWithAppleButtonStyle(.white)
            .frame(height: 50)
            .padding(.horizontal, 40)
            .padding(.top, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("mainColor")) // 필요 시 배경 컬러 추가
    }
    
    func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    func randomNonceString(length: Int = 32) -> String {
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

}

#Preview {
    LoginView()
}
