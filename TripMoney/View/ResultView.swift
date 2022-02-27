//
//  ResultView.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/27.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var event: Event

    var body: some View {
        NavigationView {
            List {
                ForEach(event.individualCost()) { result in
                    Section {
                        ForEach(result.costs) { cost in
                            HStack {
                                Text(cost.title)
                                Spacer()
                                Text(String(cost.cost))
                            }
                            .font(.callout)
                        }
                    } header: {
                        Text(result.people.title)
                            .font(.body.weight(.bold))
                            .foregroundColor(.primary)
                            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 0))
                    } footer: {
                        Text("총 합: \(String(result.costs.reduce(0,{$0 + $1.cost})))")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle(Text("정산 결과"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {dismiss()}) {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                    }
                    .tint(.primary)
                }
            }
            .safeAreaInset(edge: .bottom ) {
                Text("총 합: \(event.totalCost()) 원")
                    .font(.title3.weight(.semibold))
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 45, alignment: .trailing)
                    .background(.ultraThinMaterial)
            }
        }
        .interactiveDismissDisabled(true)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(event: .constant(.example))
    }
}
