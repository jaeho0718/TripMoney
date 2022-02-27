//
//  DataStore.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

@MainActor
class DataStore: ObservableObject {
    @Published var events = [Event]()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    init(_ isTest: Bool = false) {
        if isTest {
            self.events = [.example]
        } else {
            do {
                try load()
            } catch {
                #if DEBUG
                print("[Init] Load Data Error")
                #endif
            }
        }
    }

    func load() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {fatalError("No URL")}
        let fileURL = documentDirectoryURL.appendingPathComponent("events.json")
        let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
        let result = try decoder.decode([Event].self, from: data)
        self.events = result
    }

    func toLocal() throws {
        let data = try encoder.encode(events)
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {fatalError("No URL")}
        let fileURL = documentDirectoryURL.appendingPathComponent("events.json")
        try data.write(to: fileURL)
    }

    func save(_ trip: Event) {
        events.insert(trip, at: 0)
        do {
            try toLocal()
        } catch {
            #if DEBUG
            print("Save Error")
            #endif
        }
    }

    func update(_ trip: Event) {
        if let index = events.firstIndex(where: {$0.id == trip.id}) {
            events[index] = trip
            do {
                try toLocal()
            } catch {
                #if DEBUG
                print("Save Error")
                #endif
            }
        }
    }

    func delete(_ indexOffset: IndexSet) {
        events.remove(atOffsets: indexOffset)
        do {
            try toLocal()
        } catch {
            #if DEBUG
            print("Save Error")
            #endif
        }
    }

    func delete(_ trip: Event) {
        if let index = events.firstIndex(where: {$0.id == trip.id}) {
            events.remove(at: index)
            do {
                try toLocal()
            } catch {
                #if DEBUG
                print("Save Error")
                #endif
            }
        }
    }

    func edit(from indexOffset: IndexSet,to destination: Int) {
        events.move(fromOffsets: indexOffset, toOffset: destination)
        do {
            try toLocal()
        } catch {
            #if DEBUG
            print("Save Error")
            #endif
        }
    }
}
