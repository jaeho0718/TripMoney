//
//  CostPeopleList.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/27.
//

import SwiftUI
import UniformTypeIdentifiers

struct CostPeopleList: View {
    var peoples: [People]
    @Binding var cost: Cost

    var body: some View {
        List {
            Section {
                if cost.peoples.isEmpty {
                    Text("해당하는 사람 없음")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                ForEach(cost.peoples) { people in
                    Text(people.title)
                        .font(.body)
                }
                .onDelete(perform: {cost.peoples.remove(atOffsets: $0)})
            } header: {
                Text("내야 할 사람")
                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 0))
            } footer: {
                Text("왼쪽으로 스와이프해 삭제하기")
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            Section {
                if !peoples.contains(where: { p in !cost.peoples.contains(where: {p.id == $0.id})}) {
                    Text("제외된 사람 없음")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .transition(AnyTransition.opacity)
                }
                ForEach(peoples.filter({ p in !cost.peoples.contains(where: {p.id == $0.id})})) { people in
                    Text(people.title)
                        .font(.body)
                        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                            Button(action: {
                                withAnimation(.easeIn) {
                                    cost.peoples.append(people)
                                }
                            }) {
                                Image(systemName: "plus")
                            }
                            .tint(.green)
                        })
                }
            } header: {
                Text("제외 된 사람")
                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 3, trailing: 0))
            } footer: {
                Text("오른쪽으로 스와이프해 추가하기")
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .listStyle(.grouped)
        .navigationTitle(Text(cost.title))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CostPeopleList_Previews: PreviewProvider {
    static var previews: some View {
        CostPeopleList(peoples: [],cost: .constant(.example))
    }
}
