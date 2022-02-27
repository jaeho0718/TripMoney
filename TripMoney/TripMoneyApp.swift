//
//  TripMoneyApp.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

@main
struct TripMoneyApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var store = DataStore()
    @StateObject var system = SystemData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(system)
        }
        .onChange(of: scenePhase, perform: { value in
            system.scenePhase = value
            if value != .active {
                do {
                    try store.toLocal()
                } catch {}
            }
        })
    }
}
