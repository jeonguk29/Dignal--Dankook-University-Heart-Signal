//
//  ContentView.swift
//  Dignal
//
//  Created by 정정욱 on 3/28/25.
//

import SwiftUI
/*
 키, 채형, 안경우무, 무슨상(닮은 연애인 대신), 나이
 
 취미 - fix - 1 - 30분전
 나이 - 보류 - 3 - 25분전
 나의 생각하는 강점 - fix -4 - 20분전
 한마디 - fix - 10분전
 OOTD - fix - 5분전
 외형적인거 빼고

 -------------------------------

 결제한 사람만 - 앱 다운 큐알 보여주기
 카카오페이로 모든 자금을 관리함
 
 애프터 여뷰 - ?? 

 */

struct ContentView: View {
    @State private var showGuide: Bool = false
    @State private var showInfo: Bool = false
    @State var showAlert: Bool = false
    @GestureState private var dragState = DragState.inactive
    private var dragAreaThreshold: CGFloat = 65.0
    @State private var cardRemovalTransition = AnyTransition.trailingBottom
    
    let userArray: [User] = [
        User(name: "정우", studentID: "32200000", gender: "남자", isDKUStudent: true, phoneNumber: "010-1234-5678", mbti: "ENFP", age: "21", height: "175", lookalike: "차은우", instagramID: "jungwoo_insta"),
        User(name: "수빈", studentID: "32200001", gender: "여자", isDKUStudent: false, phoneNumber: "010-2222-3333", mbti: "ISFJ", age: "22", height: "162", lookalike: "아이유", instagramID: "subin_iu"),
        User(name: "지훈", studentID: "32200002", gender: "남자", isDKUStudent: true, phoneNumber: "010-9876-5432", mbti: "INTJ", age: "23", height: "180", lookalike: "정해인", instagramID: "jihun_haein"),
        User(name: "예린", studentID: "32200003", gender: "여자", isDKUStudent: true, phoneNumber: "010-4567-8901", mbti: "ESFP", age: "20", height: "165", lookalike: "김태리", instagramID: "yerin_taeri")
    ]
    
    let questions = [
        "상대방 이름은?",
        "상대방 MBTI는?",
        "상대방 닮은꼴은?",
        "상대방 인스타그램은?"
    ]
    
    let backgroundImages = [
        "photo-athens-greece", "photo-barcelona-spain", "photo-budapest-hungary", "photo-dubai-emirates",
        "photo-emaraldlake-canada", "photo-grandcanyon-usa", "photo-krabi-thailand", "photo-lakebled-slovenia",
        "photo-london-uk", "photo-newyork-usa", "photo-paris-france", "photo-riodejaneiro-brazil",
        "photo-rome-italy", "photo-sanfrancisco-usa", "photo-seoraksan-southkorea", "photo-sydney-australia",
        "photo-tatras-poland", "photo-tulum-mexico", "photo-veligandu-island-maldives", "photo-venice-italy",
        "photo-yosemite-usa"
    ]
    
    @State var cardViews: [CardView] = []
    
    var body: some View {
        VStack {
            // MARK: - HEADER
            HeaderView(showGuideView: $showGuide, showInfoView: $showInfo)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
            
            Spacer()
            
            ZStack {
                ForEach(cardViews) { cardView in
                    cardView
                        .zIndex(self.isTopCard(cardView: cardView) ? 1 : 0)
                        .overlay(content: {
                            ZStack(content: {
                                Image(systemName: "x.circle")
                                    .modifier(SymbolModifier())
                                    .opacity(self.dragState.translation.width < -dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                                Image(systemName: "heart.circle")
                                    .modifier(SymbolModifier())
                                    .opacity(self.dragState.translation.width > dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                            })
                        })
                        .offset(x: self.isTopCard(cardView: cardView) ? self.dragState.translation.width : 0,
                                y: self.isTopCard(cardView: cardView) ? self.dragState.translation.height : 0)
                        .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.85 : 1.0)
                        .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 12) : 0))
                        .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                        .gesture(
                            LongPressGesture(minimumDuration: 0.01)
                                .sequenced(before: DragGesture())
                                .updating(self.$dragState) { value, state, _ in
                                    switch value {
                                    case .first(true):
                                        state = .pressing
                                    case .second(true, let drag):
                                        state = .dragging(translation: drag?.translation ?? .zero)
                                    default:
                                        break
                                    }
                                }
                                .onEnded { value in
                                    guard case .second(true, let drag?) = value else { return }
                                    if abs(drag.translation.width) > self.dragAreaThreshold {
                                        playSound(sound: "sound-rise", type: "mp3")
                                        self.moveCards()
                                    }
                                }
                        )
                        .transition(self.cardRemovalTransition)
                }
            }
            
            Spacer()
            
            // MARK: - FOOTER
            FooterView(showBookingAlert: $showAlert)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("SUCCESS"), message: Text("매칭이 완료되었습니다."), dismissButton: .default(Text("확인")))
                }
        }
        .sheet(isPresented: $showGuide) {
            Text("가이드 화면")
                .font(.largeTitle)
                .padding()
        }
        .sheet(isPresented: $showInfo) {
            Text("정보 화면")
                .font(.largeTitle)
                .padding()
        }
        .onAppear {
            setupCards()
        }
    }
    
    private func setupCards() {
        cardViews = []
        for (index, user) in userArray.enumerated() {
            let question = questions[index % questions.count]
            let answer: String = {
                switch question {
                case "상대방 이름은?": return user.name
                case "상대방 MBTI는?": return user.mbti
                case "상대방 닮은꼴은?": return user.lookalike
                case "상대방 인스타그램은?": return "@\(user.instagramID)"
                default: return ""
                }
            }()
            let image = backgroundImages.randomElement() ?? "photo-paris-france"
            let card = CardView(imageName: image, question: question, answer: answer)
            cardViews.append(card)
        }
    }
    
    private func moveCards() {
        guard !cardViews.isEmpty else {
            setupCards()
            return
        }
        cardViews.removeFirst()
        if cardViews.isEmpty {
            setupCards()
        }
    }
    
    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else { return false }
        return index == 0
    }
    
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing: return .zero
            case .dragging(let translation): return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing: return false
            case .dragging: return true
            }
        }
        
        var isPressing: Bool {
            switch self {
            case .inactive, .dragging: return false
            case .pressing: return true
            }
        }
    }
}

#Preview {
    ContentView()
}
