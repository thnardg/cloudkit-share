//
//  ShareDataViaCloudKitApp.swift
//  ShareDataViaCloudKit
//
//  Created by Thayna Rodrigues on 02/10/24.
//

import SwiftUI
import CoreData

@main
struct SwiftUIShareData: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let container = CoreDataStack.shared.persistentContainer

    var body: some Scene {
        WindowGroup {
            if let room = fetchRoom() {
                MainTabView(room: room)
                    .environment(\.managedObjectContext, container.viewContext)
            } else {
                NewRoomView()
                    .environment(\.managedObjectContext, container.viewContext)
            }
        }
    }

    // fetch pra saber qual a room certa caso já tenha passado pelo onboarding
    private func fetchRoom() -> Room? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
        
        do {
            let rooms = try context.fetch(fetchRequest)
            return rooms.first { room in
                (room.users?.count ?? 0) >= 1 // vê qual room tem pelo menos um user
            }
        } catch {
            print("Error fetching rooms: \(error)")
            return nil
        }
    }
}
