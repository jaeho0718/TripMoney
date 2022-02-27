//
//  PeopleEditor.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/27.
//

import SwiftUI

struct PeopleEditor: View {
    @EnvironmentObject var store: DataStore
    @State private var showEditor: Bool = false
    @State private var newPeoples = [People]()
    @Binding var event: Event

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button(action: {
                    showEditor.toggle()
                }) {
                    Image(systemName: "plus")
                        .frame(width: 50, height: 50)
                        .background(Circle().foregroundStyle(.ultraThickMaterial))
                }
                .tint(.primary)
                .buttonStyle(.plain)
                ForEach(event.peoples) { people in
                    if let title = people.title.first {
                        Menu {
                            Text(people.title)
                            Button(role: .destructive, action: {
                                for cost in event.costs {
                                    if let index = event.costs.firstIndex(where: {$0.id == cost.id}) {
                                        event.costs[index].peoples.removeAll(where: {$0.id == people.id})
                                    }
                                }
                                event.peoples.removeAll(where: {$0.id == people.id})
                            }, label: {Text("삭제")})
                        } label: {
                            Text(String(title))
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .frame(width: 50, height: 50)
                                .background(Circle().foregroundStyle(.ultraThickMaterial))
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showEditor, onDismiss: {newPeoples.removeAll()}) {
            NavigationView {
                List {
                    ForEach($newPeoples) { $newPeople in
                        TextField("이름", text: $newPeople.title)
                            .font(.callout)
                    }
                    .onDelete(perform: {newPeoples.remove(atOffsets: $0)})
                    Button(action: {
                        let newPeople = People(title: "")
                        withAnimation(.easeInOut) {
                            newPeoples.append(newPeople)
                        }
                    }) {
                        Label("사람 추가", systemImage: "plus.circle.fill")
                            .font(.callout)
                    }
                }
                .listStyle(.inset)
                .navigationTitle(Text("사람"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            event.peoples.append(contentsOf: newPeoples)
                            for cost in event.costs {
                                if let index = event.costs.firstIndex(where: {$0.id == cost.id}) {
                                    event.costs[index].peoples.append(contentsOf: newPeoples)
                                }
                            }
                            store.update(event)
                            showEditor = false
                        }) {
                            Text("추가")
                        }
                        .disabled(newPeoples.contains(where: {$0.title.isEmpty}) || newPeoples.isEmpty)
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct PeopleEditor_Previews: PreviewProvider {
    static var previews: some View {
        PeopleEditor(event: .constant(.example))
            .environmentObject(DataStore())
    }
}
