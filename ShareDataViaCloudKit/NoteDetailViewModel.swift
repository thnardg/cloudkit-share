//
//  NoteDetailViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 04/10/24.
//

import Foundation
import SwiftUI
import CloudKit

class NoteDetailViewModel: ObservableObject {
    private let stack = CoreDataStack.shared
    @Published var sharing = false
    @Published var newMemoText: String = ""

    func addMemo(to note: Note) {
        if !newMemoText.isEmpty {
            stack.addMemo(note, text: newMemoText)
            newMemoText = ""
        }
    }

    func deleteMemo(_ memo: Memo) {
        stack.deleteMemo(memo)
    }

    func changeMemoText(_ memo: Memo) {
        stack.changeMemoText(memo)
    }

    func incrementCounter(_ counter: Counter, for note: Note) {
        if stack.isOwner(object: note) {
            counter.userOneCount += 1
        } else {
            counter.userTwoCount += 1
        }
        self.stack.incrementCounter(counter)
    }


        func createCounter(for note: Note) {
            stack.addCounter(to: note)
        }


    
    func createShare(for note: Note) async {
        sharing = true
        do {
            let (_, share, _) = try await stack.persistentContainer.share([note], to: nil)
            share[CKShare.SystemFieldKey.title] = note.name
        } catch {
            print("Failed to create share")
            sharing = false
        }
        sharing = false
    }

    func isShared(note: Note) -> Bool {
        return stack.isShared(object: note)
    }

    func canEdit(note: Note) -> Bool {
        return stack.canEdit(object: note)
    }
}
