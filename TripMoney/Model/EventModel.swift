//
//  TripModel.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import Foundation

struct Event: Identifiable, Codable {

    init(title: String, costs: [Cost]) {
        self.id = UUID()
        self.title = title
        self.costs = costs
        self.people = 1
    }

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.costs = [Cost]()
        self.people = 1
    }

    var id: UUID
    var title: String
    var people: Int
    var costs: [Cost]
    
    func totalCost() -> Int {
        self.costs.reduce(0) {$0 + $1.cost}
    }

    func individualCost() -> CostResult {
        let averageCost = costs.reduce(0) {$0 + $1.cost}/people
        let remaining = costs.reduce(0) {$0 + $1.cost}-averageCost*people
        if people > 1 && averageCost != averageCost+remaining {
            return CostResult(averageCost: averageCost, averageCount: people-1, remainingCost: remaining+averageCost, remainingCount: 1)
        } else {
            return CostResult(averageCost: averageCost, averageCount: people, remainingCost: 0, remainingCount: 0)
        }
    }

    struct CostResult {
        var averageCost: Int
        var averageCount: Int
        var remainingCost: Int
        var remainingCount: Int
    }
}

// MARK: - 예제
extension Event {
    static let example = Event(title: "남양주 여행", costs: [.example, .example2])
}
