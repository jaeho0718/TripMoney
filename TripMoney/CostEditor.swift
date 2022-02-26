//
//  CostEditor.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

struct CostEditor: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var store: DataStore
    @Namespace var transition
    @Binding var event: Event
    @State private var showEditor: Bool = false
    @State private var cost = Cost()
    @FocusState private var keyboard: Keyboard?
    enum Keyboard {
        case title, cost
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                if showEditor {
                    Text("비용 편집기")
                        .font(.body.weight(.semibold))
                        .frame(width: 300, height: 40, alignment: .leading)
                        .matchedGeometryEffect(id: "bottomTitle", in: transition)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text("\(event.individualCost().averageCount) 명이 \(event.individualCost().averageCost) 원")
                            if event.individualCost().remainingCount != 0 {
                                Text("\(event.individualCost().remainingCount) 명이 \(event.individualCost().remainingCost) 원")
                            }
                        }
                    }
                        .font(.body.weight(.semibold))
                        .lineLimit(1)
                        .frame(width: 300, height: 40, alignment: .leading)
                        .matchedGeometryEffect(id: "bottomTitle", in: transition)
                }
                Spacer()
                Button(action: {
                    withAnimation(.easeIn) {
                        showEditor.toggle()
                    }
                }) {
                    Image(systemName: showEditor ? "xmark" : "plus")
                        .imageScale(.medium)
                }
                .tint(.primary)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            if showEditor {
                Divider()
                VStack(alignment: .leading, spacing: 10) {
                    TextField("제목", text: $cost.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($keyboard, equals: .title)
                        .onSubmit {
                            if cost.cost == 0 {
                                keyboard = .cost
                            }
                        }
                    TextField("비용", text: Binding<String>(get: {String(cost.cost)}, set: {cost.cost = Int($0) ?? 0}))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($keyboard, equals: .cost)
                        .onSubmit {
                            if cost.title.isEmpty {
                                keyboard = .title
                            }
                        }
                    Button(action: {
                        event.costs.append(cost)
                        store.update(event)
                        withAnimation(.easeIn) {
                            showEditor = false
                        }
                        cost = Cost()
                    }) {
                        Text("저장")
                            .frame(maxWidth: .infinity, minHeight: 35)
                            .foregroundColor(colorScheme == .light ? .white : .black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primary)
                    .disabled(cost.title.isEmpty || cost.cost == 0)

                }
                .padding(15)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                .transition(AnyTransition.move(edge: .bottom))
            }
        }
        .background(.background)
    }
}

struct CostEditor_Previews: PreviewProvider {
    static var previews: some View {
        CostEditor(event: .constant(.example))
            .environmentObject(DataStore(true))
    }
}
