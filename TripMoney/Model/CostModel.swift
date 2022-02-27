//
//  CostModel.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import Foundation

struct Cost: Identifiable, Codable {

    init(title: String, cost: Int) {
        self.id = UUID()
        self.title = title
        self.cost = cost
        self.peoples = []
    }

    init() {
        self.id = UUID()
        self.title = ""
        self.cost = .zero
        self.peoples = []
    }

    var id: UUID
    var title: String
    var cost: Int
    var peoples: [People]
}

// MARK: - 예제
extension Cost {
    static let example = Cost(title: "숙소비", cost: 163000)
    static let example2 = Cost(title: "간식비", cost: 13000)
}
