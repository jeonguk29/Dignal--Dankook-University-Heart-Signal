//
//  ContentView.swift
//  Dignal
//
//  Created by 정정욱 on 3/28/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var showAlert: Bool = false
    @State var showGuide: Bool = false
    @State var showInfo: Bool = false
    @GestureState private var dragState = DragState.inactive
    
    private var dragAreaThreshold: CGFloat = 65.0
    // 해당 상 수 값을 기준으로 카드를 왼, 오른쪽 드래그시 보이는 아이콘을 다르게 표시
    
    
    @State private var lastCardIndex: Int = 1 // 현재 마지막 카드의 인덱스를 추적하는 변수로, 새로운 카드를 추가할 때 사용
    
    @State private var cardRemovalTransition = AnyTransition.trailingBottom
    
    // MARK: - CARD VIEWS
    @State var cardViews: [CardView] = {
        var views = [CardView]()
        for index in 0 ..< 2 {
            views.append(CardView(honeyMoon: destinationArray[index]))
        }
        return views
    }()
    
    
    // moveCards 함수는 최상위 카드를 제거하고 새로운 카드를 추가하는 기능을 합니다.
    // 사실상 무한 순환 하며 새로운 카드뷰를 추가하는 방식
    private func moveCards() {
        cardViews.removeFirst()
        self.lastCardIndex += 1
        
        let honeymoon = destinationArray[lastCardIndex % destinationArray.count]
        
        let newCardView = CardView(honeyMoon: honeymoon)
        cardViews.append(newCardView)
        
    }
    
    
    /*
     isTopCard 메서드는 특정 cardView가 카드 스택의 최상위에 있는지 확인합니다.
     cardViews 배열에서 주어진 cardView의 인덱스를 찾고, 그 인덱스가 0인지(즉, 최상위인지) 확인합니다.
     cardView의 id 속성을 이용해 cardViews 배열에서 일치하는 항목을 찾습니다.
     
     */
    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }
        
        return index == 0
    }
    
    // MARK: - Drag State
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
    
    var body: some View {
        
        
        VStack(content: {
            
            // MARK: - HEADER
            HeaderView(showGuideView: $showGuide, showInfoView: $showInfo)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
            
            Spacer()
            
            
            // MARK: - CARDS
            ZStack {
                ForEach(cardViews) { cardView in
                    cardView
                        .zIndex(self.isTopCard(cardView: cardView) ? 1 : 0) // zIndex를 1로 설정하여 다른 카드보다 위에 나타나도록 합니다. 그렇지 않으면 0으로 설정합니다.
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
                        .offset(x: self.isTopCard(cardView: cardView) ? self.dragState.translation.width : 0, y: self.isTopCard(cardView: cardView) ? self.dragState.translation.height : 0)
                            //최상위 카드일 경우 드래그 상태에 따라 x와 y 축으로 이동합니다. 그렇지 않으면 기본 위치에 유지됩니다.
                    
                        .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.85 : 1.0)
                        //드래그 중일 때 최상위 카드는 크기를 0.85로 줄입니다. 그렇지 않으면 원래 크기(1.0)를 유지
                        .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 12) : 0)) // 최상위 카드일 경우 드래그의 x 축 이동에 따라 회전 각도를 설정합니다. 그렇지 않으면 회전하지 않습니다.
                        .animation(.interpolatingSpring(stiffness: 120, damping: 120)) // interpolatingSpring 애니메이션을 사용하여 뷰가 자연스럽게 움직이도록 합니다. stiffness와 damping 값을 설정하여 애니메이션의 탄성 정도를 조절합니다.
                        .gesture(
                            LongPressGesture(minimumDuration: 0.01)
                                .sequenced(before: DragGesture())
                                .updating(self.$dragState) { value, state, transaction in
                                    switch value {
                                    case .first(true):
                                        state = .pressing
                                    case .second(true, let drag):
                                        state = .dragging(translation: drag?.translation ?? .zero)
                                    default:
                                        break
                                    }
                                }
                                .onChanged({ (value) in
                                    guard case .second(true, let drag?) = value else {
                                        return
                                    }
                                    // 뷰가 왼쪽 오른쪽 사라질때 확장 애니메이션 추가
                                    if drag.translation.width < -self.dragAreaThreshold {
                                        self.cardRemovalTransition = .leadingBottom
                                    }
                                    
                                    if drag.translation.width > self.dragAreaThreshold {
                                        self.cardRemovalTransition = .trailingBottom
                                    }
                                })
                                .onEnded { value in
                                    // 제스처가 끝났을 때 호출됩니다.
                                    // 사용자가 카드를 드래그하여 일정 거리 이상 움직였을 때 최상위 카드를 제거하고 새로운 카드를 추가
                                    guard case .second(true, let drag?) = value else {
                                        return
                                    }
                                    
                                    if drag.translation.width < -self.dragAreaThreshold || drag.translation.width > self.dragAreaThreshold {
                                        playSound(sound: "sound-rise", type: "mp3")
                                        self.moveCards()
                                    }
                                }
                        ).transition(self.cardRemovalTransition)
                    /*LongPressGesture와 DragGesture를 순서대로 인식합니다.
                    updating 블록에서는 제스처 상태(dragState)를 업데이트합니다.
                    .first(true): 길게 누르기가 시작된 상태입니다. 이 상태에서는 state를 .pressing으로 설정합니다.
                    .second(true, let drag): 드래그가 시작된 상태입니다. 이 상태에서는 state를 드래그 번역 값으로 설정합니다.
                    default: 다른 모든 상태는 무시합니다.
                     */
                    
                        
                }
                
            }
            
            Spacer()
            
            
            // MARK: - FOOTER
            FooterView(showBookingAlert: $showAlert)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
            
            
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("SUCCESS"),
                  message: Text("wishing a lovely and most precious of the times together for the amazing couple."),
                  dismissButton: .default(Text("Happy Honeymoon!"))
            )
        })
    }
}

#Preview {
    ContentView()
}
