//
//  CounterView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import SwiftUI

struct CounterView: View {
    let room: Room // instância da "sala" compartilhada
    @StateObject private var viewModel = NoteDetailViewModel()
    @FetchRequest private var counters: FetchedResults<Counter> // fetch do dado compartilhado

    // inicializa a sala com as infos que foram compartilhadas nela
    init(room: Room) {
        self.room = room
        
        _counters = FetchRequest(entity: Counter.entity(),
                                 sortDescriptors: [],
                                 predicate: NSPredicate(format: "%K = %@", #keyPath(Counter.room), room),
                                 animation: .default)
    }

    var body: some View {
        VStack {
            if let counter = counters.first { //checa se existe um contador
                HStack {
                    VStack {
                        Text("User 1: \(counter.userOneCount)")
                            .font(.headline)
                        Text("User 2: \(counter.userTwoCount)")
                            .font(.headline)
                    }.padding()

                    Button(action: {
                        viewModel.incrementCounter(counter, for: room)
                    }) {
                        Text("Counted")
                            .padding(5)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
            }
        }.onAppear {
            if counters.isEmpty {
                viewModel.createCounter(for: room)
            }
        }
    }
}
