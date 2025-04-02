//
//  UserInfoView.swift
//  Dignal
//
//  Created by 정정욱 on 3/29/25.
//

import SwiftUI

struct UserInfoView: View {
    @State private var name = ""
    @State private var studentID = ""
    @State private var gender = "남자"
    @State private var isDKUStudent = false
    @State private var phoneNumber = ""
    @State private var mbti = ""
    @State private var age = ""
    @State private var height = ""
    @State private var lookalike = ""
    @State private var instagramID = ""

    let genderOptions = ["남자", "여자"]

    var isFormValid: Bool {
        return !name.isEmpty &&
        !studentID.isEmpty &&
        !phoneNumber.isEmpty &&
        !mbti.isEmpty &&
        !age.isEmpty &&
        !height.isEmpty &&
        !lookalike.isEmpty &&
        !instagramID.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 타이틀
                Text("어필 정보 입력")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.navyText)
                    .padding(.top, 40)

                // 입력 필드 카드
                Group {
                    RoundedInput(title: "이름", text: $name)
                    RoundedInput(title: "학번", text: $studentID)

                    VStack(alignment: .leading) {
                        Text("성별")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.navyText)
                        Picker("성별", selection: $gender) {
                            ForEach(genderOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    HStack {
                        Text("단국대생이신가요?")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.navyText)

                        Spacer()

                        Toggle("", isOn: $isDKUStudent)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: .darkCoral))
                    }
                    .padding(.top, 10)


                    RoundedInput(title: "휴대폰 번호", text: $phoneNumber, keyboard: .phonePad)
                    RoundedInput(title: "MBTI", text: $mbti)
                    RoundedInput(title: "나이", text: $age, keyboard: .numberPad)
                    RoundedInput(title: "키 (cm)", text: $height, keyboard: .numberPad)
                    RoundedInput(title: "닮은꼴 연예인", text: $lookalike)
                    RoundedInput(title: "인스타그램 ID", text: $instagramID)
                }

                // 다음 버튼
                Button(action: {
                    // 다음 페이지로 이동
                }) {
                    Text("다음")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.darkCoral : Color.gray.opacity(0.4))
                        .cornerRadius(12)
                        .animation(.easeInOut, value: isFormValid)
                }
                .disabled(!isFormValid)
                .padding(.top, 20)
            }
            .padding()
        }
        .background(Color.coralPink.ignoresSafeArea())
    }
}

// MARK: - Custom Rounded Input Field
struct RoundedInput: View {
    let title: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.navyText)

            TextField("입력해주세요", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .keyboardType(keyboard)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .gray.opacity(0.05), radius: 3, x: 0, y: 2)
        }
    }
}

// MARK: - Color Extension
extension Color {
    static let coralPink = Color(hex: "#FF8A8A")
    static let darkCoral = Color(hex: "#F45D5D")
    static let navyText = Color(hex: "#2F2F3A")

    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    UserInfoView()
}
