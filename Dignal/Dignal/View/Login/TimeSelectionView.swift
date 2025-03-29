//
//  TimeSelectionView.swift
//  Dignal
//
//  Created by 정정욱 on 3/29/25.
//

import SwiftUI

struct TimeSelectionView: View {
    let day1 = "3월 30일"
    let day2 = "3월 31일"
    let times = Array(9...20)

    @State private var selectedTimesDay1: Set<Int> = []
    @State private var selectedTimesDay2: Set<Int> = []

    var isFormValid: Bool {
        !selectedTimesDay1.isEmpty && !selectedTimesDay2.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 36) {
                Text("하루씩 가능한 시간을 선택해주세요")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.navyText)
                    .padding(.top, 40)
                    .padding(.horizontal)

                // 🔹 Day 1
                TimeSectionView(
                    title: day1,
                    selectedTimes: $selectedTimesDay1,
                    times: times
                )

                // 🔹 Day 2
                TimeSectionView(
                    title: day2,
                    selectedTimes: $selectedTimesDay2,
                    times: times
                )

                // 완료 버튼
                Button(action: {
                    print("🔸 \(day1): \(selectedTimesDay1.sorted())")
                    print("🔸 \(day2): \(selectedTimesDay2.sorted())")
                }) {
                    Text("완료")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.darkCoral : Color.gray.opacity(0.4))
                        .cornerRadius(12)
                }
                .disabled(!isFormValid)
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .background(Color.coralPink.ignoresSafeArea())
    }
}

// MARK: - 시간 선택 카드 뷰
struct TimeSectionView: View {
    let title: String
    @Binding var selectedTimes: Set<Int>
    let times: [Int]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.navyText)
                .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(times, id: \.self) { hour in
                    let isSelected = selectedTimes.contains(hour)

                    Text("\(hour)시")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isSelected ? Color.darkCoral : Color.white)
                        .foregroundColor(isSelected ? .white : .navyText)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .onTapGesture {
                            if isSelected {
                                selectedTimes.remove(hour)
                            } else {
                                selectedTimes.insert(hour)
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview
#Preview {
    TimeSelectionView()
}
