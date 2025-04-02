//
//  LoginViewModel.swift
//  Dignal
//
//  Created by 정정욱 on 4/1/25.
//

import CryptoKit
import Foundation
import AuthenticationServices
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var currentNonce: String?
    var appState: AppState?  // 주입됨

    func handleAppleLogin(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            guard
                let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
                let identityToken = appleIDCredential.identityToken,
                let tokenString = String(data: identityToken, encoding: .utf8)
            else {
                print("⚠️ Apple 로그인 토큰 에러")
                return
            }

            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: tokenString,
                rawNonce: currentNonce ?? ""  // 추후 보안 강화 시 사용
            )

            Auth.auth().signIn(with: credential) { [self] authResult, error in
                if let error = error {
                    print("❌ Firebase 로그인 실패: \(error.localizedDescription)")
                    return
                }

                if let user = authResult?.user {
                    print("✅ Firebase 로그인 성공 - UID: \(user.uid)")
                    // 👉 여기서 UID를 저장하거나, 서버에 전송하면 됨
                    appState?.isLoggedIn = true
                }
            }

        case .failure(let error):
            print("❌ Apple 로그인 실패: \(error.localizedDescription)")
        }
    }
}
