//
//  AppState.swift
//  Dignal
//
//  Created by 정정욱 on 4/2/25.
//

import Foundation

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = {
        return UserDefaults.standard.string(forKey: "firebaseUID") != nil
    }()

    func login(with uid: String) {
        UserDefaults.standard.set(uid, forKey: "firebaseUID")
        isLoggedIn = true
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "firebaseUID")
        isLoggedIn = false
    }
}
