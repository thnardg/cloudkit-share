//
//  NoteDetailView.swift
//  ShareDataViaCloudKit
//
//  Created by Thayna Rodrigues on 02/10/24.
//

import CloudKit
import CoreData
import Foundation
import SwiftUI
import UIKit

struct NoteDetailView: View {
    let note: Note
    private let stack = CoreDataStack.shared
    
    @State private var showShareController = false
    @State private var newMemoText: String = "" 
    
    @FetchRequest(
         entity: Memo.entity(),
         sortDescriptors: [NSSortDescriptor(keyPath: \Memo.timestamp, ascending: false)],
         animation: .default
     ) private var memos: FetchedResults<Memo>
     
    @State private var sharing = false
    
    init(note: Note) {
        self.note = note
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(memos) { memo in
                    Text(memo.text ?? "")
                        .swipeActions {
                            if canEdit {
                                Button(role: .destructive) {
                                    stack.deleteMemo(memo)
                                } label: {
                                    Label("Del", systemImage: "trash")
                                }
                                Button {
                                    stack.changeMemoText(memo)
                                } label: {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }
                                .tint(.orange)
                            }
                        }
                }
            }
            
            if canEdit {
                HStack {
                    TextField("Write your memo here...", text: $newMemoText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        withAnimation {
                            stack.addMemo(note, text: newMemoText)
                            newMemoText = ""
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    .disabled(newMemoText.isEmpty) 
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem {
                HStack {
                    if sharing {
                        ProgressView()
                    }
                    
                    Button {
                        if isShared {
                            showShareController = true
                        } else {
                            Task.detached {
                                await createShare(note)
                            }
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .controlGroupStyle(.navigation)
            }
        }
        .navigationTitle(note.name ?? "")
        .sheet(isPresented: $showShareController) {
            let share = stack.getShare(note)!
            CloudSharingView(share: share, container: stack.ckContainer, note: note)
                .ignoresSafeArea()
        }
    }
    
    private func openSharingController(note: Note) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        
        let sharingController = UICloudSharingController {
            (_, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
            
            stack.persistentContainer.share([note], to: nil) { _, share, container, error in
                if let actualShare = share {
                    note.managedObjectContext?.performAndWait {
                        actualShare[CKShare.SystemFieldKey.title] = note.name
                    }
                }
                completion(share, container, error)
            }
        }
        
        keyWindow?.rootViewController?.present(sharingController, animated: true)
    }
    
    private var isShared: Bool {
        stack.isShared(object: note)
    }
    
    private var canEdit: Bool {
        stack.canEdit(object: note)
    }
    
    func createShare(_ note: Note) async {
        sharing = true
        do {
            let (_, share, _) = try await stack.persistentContainer.share([note], to: nil)
            share[CKShare.SystemFieldKey.title] = note.name
        } catch {
            print("Failed to create share")
            sharing = false
        }
        sharing = false
        showShareController = true
    }
}
