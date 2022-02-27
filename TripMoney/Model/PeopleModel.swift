//
//  PeopleModel.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/27.
//

import Foundation
import UniformTypeIdentifiers

struct People: Identifiable, Codable {

    init(title: String) {
        self.title = title
        self.id = UUID()
    }

    var id: UUID
    var title: String
}

extension People: Equatable, Hashable {}
