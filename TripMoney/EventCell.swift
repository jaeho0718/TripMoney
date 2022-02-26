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
    @GestureState var dragValue = CGSize.zero
    @State private var onDelete: Bool = false
    @Binding var event: Event
    private let cellHeight: CGFloat = 75
    private let cornerRadius: CGFloat = 10
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image(systemName: "trash.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .offset(x: -5)
                    .frame(width: 100, height: cellHeight)
                    .background {
                        Rectangle()
                            .foregroundColor(.red)
                    }
                    .cornerRadius(cornerRadius)
                    .offset(x: proxy.size.width/2 + 50)
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            self.onDelete = false
                            store.delete(event)
                        }
                    }
                Group {
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
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            self.onDelete = false
                        }
                        system.sheet = .event(event)
                    }
            }
            .offset(x: dragValue.width)
            .offset(x: onDelete ? -90 : 0)
            .frame(width: proxy.size.width, height: cellHeight)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .animation(.easeInOut, value: dragValue.width)
        }
        .frame(height: cellHeight)
        .gesture(DragGesture().updating($dragValue, body: { value, state, transaction in
            if value.translation.width > -95 && value.translation.width < 0 && !onDelete {
                state = value.translation
            } else if value.translation.width > 0 {
                state = .zero
                DispatchQueue.main.async {
                    withAnimation(.easeIn) {
                        self.onDelete = false
                    }
                }
            }
        }).onEnded({ value in
            if value.translation.width < -80 {
                onDelete = true
            } else {
                onDelete = false
            }
        }))
    }
}

struct EventCell_Previews: PreviewProvider {
    static var previews: some View {
        EventCell(event: .constant(.example))
            .environmentObject(SystemData())
            .environmentObject(DataStore(true))
            .environment(\.editMode, .constant(.active))
    }
}
