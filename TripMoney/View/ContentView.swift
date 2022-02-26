//
//  ContentView.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = DataStore()
    @StateObject var system = SystemData()
    @State private var search: String = ""

    var body: some View {
        NavigationView {
            EventList()
                .navigationTitle(Text("이벤트"))
        }
            .fullScreenCover(item: $system.sheet, content: { sheet in
                switch sheet {
                case .event(let event):
                    EventView(event: event)
                }
            })
            .environmentObject(store)
            .environmentObject(system)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
