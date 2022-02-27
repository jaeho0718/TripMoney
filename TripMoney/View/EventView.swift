//
//  TripView.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

struct EventView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var store: DataStore
    @EnvironmentObject var system: SystemData
    @State private var event: Event

    init(event: Event) {
        _event = .init(initialValue: event)
    }

    var body: some View {
        NavigationView {
            List {
                PeopleEditor(event: $event)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 5))
                    .listRowBackground(Color.clear)
                Section {
                    if event.costs.isEmpty {
                        Text("비용을 추가해주세요.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach($event.costs) { $cost in
                            NavigationLink(destination: {
                                CostPeopleList(peoples: event.peoples, cost: $cost)
                                    .onDisappear {
                                        store.update(event)
                                    }
                            }) {
                                CostCell(cost: cost)
                            }
                        }
                        .onDelete(perform: {event.costs.remove(atOffsets: $0)})
                        .onMove(perform: {(indexSet, destination) in
                            event.costs.move(fromOffsets: indexSet, toOffset: destination)
                        })
                    }
                } header: {
                    Label("비용", systemImage: "dollarsign.circle.fill")
                        .listRowInsets(EdgeInsets(top: 10, leading: 2,
                                                  bottom: 5, trailing: 0))
                } footer: {
                    Text("총 \(String(event.totalCost())) 원")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .listRowInsets(EdgeInsets(top: 7, leading: 0,
                                                  bottom: 5, trailing: 4))
                }
            }
            .navigationTitle(Text(event.title))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {system.sheet = nil}) {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                    }
                    .tint(.primary)
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CostEditor(event: $event)
        }
        .onDisappear {
            store.update(event)
        }
        .onChange(of: system.scenePhase, perform: { value in
            if value != .active {
                store.update(event)
            }
        })
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: .example)
            .environmentObject(DataStore(true))
            .environmentObject(SystemData())
    }
}
