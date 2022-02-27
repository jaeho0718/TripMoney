//
//  TripCell.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

struct EventCell: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var system: SystemData
    @EnvironmentObject var store: DataStore
    @Binding var event: Event
    private let cellHeight: CGFloat = 75
    private let cornerRadius: CGFloat = 10
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(cornerRadius)
                .foregroundColor(.primary)
            HStack {
                Text(event.title)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .lineLimit(1)
                Spacer()
                Text("총 \(String(event.totalCost())) 원")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .frame(height: cellHeight)
        .cornerRadius(cornerRadius)
        .onTapGesture {
            system.sheet = .event(event)
        }
    }
}

struct EventCell_Previews: PreviewProvider {
    static var previews: some View {
        EventCell(event: .constant(.example))
            .environmentObject(SystemData())
            .environmentObject(DataStore(true))
    }
}
