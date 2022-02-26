//
//  TripList.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

struct EventList: View {
    @EnvironmentObject var store: DataStore
    @State private var newTrip = Event(title: "")
    @FocusState private var onAdding: Bool

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($store.events) { $event in
                    EventCell(event: $event)
                        .padding(.horizontal, 15)
                        .transition(AnyTransition.asymmetric(insertion: .move(edge: .bottom),
                                                             removal: .move(edge: .leading)))
                }
            }
        }
        .navigationViewStyle(.stack)
        .safeAreaInset(edge: .bottom) {
            HStack {
                TextField("새로운 이벤트", text: $newTrip.title)
                    .focused($onAdding)
                    .onSubmit {
                        if !newTrip.title.isEmpty {
                            withAnimation(.easeIn) {
                                store.save(newTrip)
                            }
                            newTrip = Event(title: "")
                        }
                    }
                    .padding(.trailing)
                Button(action: {
                    if newTrip.title.isEmpty {
                        onAdding = true
                    } else {
                        withAnimation(.easeIn) {
                            store.save(newTrip)
                        }
                        onAdding = false
                        newTrip = Event(title: "")
                    }
                }) {
                    Image(systemName: "plus")
                }
                .tint(.primary)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(.ultraThinMaterial)
        }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
            .environmentObject(DataStore(true))
    }
}
