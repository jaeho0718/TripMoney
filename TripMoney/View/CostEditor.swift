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
    @State private var showResult: Bool = false
    @State private var cost = Cost()
    @FocusState private var keyboard: Keyboard?
    enum Keyboard {
        case title, cost
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Group {
                    if showEditor {
                        Text("비용 편집기")
                            .font(.body.weight(.semibold))
                            .matchedGeometryEffect(id: "bottomTitle", in: transition)
                    } else {
                        Button(action: {showResult.toggle()}) {
                            Text("정산")
                                .font(.caption)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .disabled(event.costs.isEmpty || event.peoples.isEmpty)
                        .matchedGeometryEffect(id: "bottomTitle", in: transition)
                    }
                }
                .frame(height: 40)
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
                        cost.peoples = event.peoples
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
        .sheet(isPresented: $showResult, content: {
            ResultView(event: $event)
        })
    }
}

struct CostEditor_Previews: PreviewProvider {
    static var previews: some View {
        CostEditor(event: .constant(.example))
            .environmentObject(DataStore(true))
    }
}
