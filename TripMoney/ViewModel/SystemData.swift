//
//  SystemData.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

class SystemData: ObservableObject {
    @Published var sheet: SheetStyle?
    @Published var scenePhase: ScenePhase?

    enum SheetStyle: Identifiable {
        case event(Event)

        var id: Int {
            switch self {
            case .event(_):
                return 1
            }
        }
    }
}
