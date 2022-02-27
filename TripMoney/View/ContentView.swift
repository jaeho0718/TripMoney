//
//  ContentView.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: DataStore
    @EnvironmentObject var system: SystemData
    @State private var search: String = ""

    var body: some View {
        NavigationView {
            EventList()
                .navigationTitle(Text("이벤트"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                            .tint(.secondary)
                    }
                }
        }
            .fullScreenCover(item: $system.sheet, content: { sheet in
                switch sheet {
                case .event(let event):
                    EventView(event: event)
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SystemData())
            .environmentObject(DataStore(true))
    }
}
