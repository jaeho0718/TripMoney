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
        self.peoples = []
    }

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.costs = [Cost]()
        self.peoples = []
    }

    var id: UUID
    var title: String
    var peoples: [People]
    var costs: [Cost]
    
    func totalCost() -> Int {
        self.costs.reduce(0) {$0 + $1.cost}
    }

    func individualCost() -> [CostResult] {
        var result = [CostResult]()
        for cost in costs {
            let averageCost = cost.cost/cost.peoples.count
            let remaining = cost.cost - averageCost*cost.peoples.count
            guard let randomPeople = cost.peoples.randomElement() else { return []}
            for people in cost.peoples {
                if let index = result.firstIndex(where: {$0.people.id == people.id}) {
                    result[index].costs.append(Cost(title: cost.title,
                                                    cost: randomPeople == people ? averageCost + remaining : averageCost))
                } else {
                    result.append(CostResult(people: people,
                                             costs: [Cost(title: cost.title,
                                                          cost: randomPeople == people ? averageCost + remaining : averageCost)]))
                }
            }
        }
        return result
    }

    struct CostResult: Identifiable {
        var id: UUID { people.id }
        var people: People
        var costs: [Cost]
    }
}

// MARK: - 예제
extension Event {
    static let example = Event(title: "남양주 여행", costs: [.example, .example2])
}
