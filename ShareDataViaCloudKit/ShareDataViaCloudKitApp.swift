//
//  ShareDataViaCloudKitApp.swift
//  ShareDataViaCloudKit
//
//  Created by Thayna Rodrigues on 02/10/24.
//

import SwiftUI

@main
struct SwiftUIShareData: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let container = CoreDataStack.shared.persistentContainer
    var body: some Scene {
        WindowGroup {
            NewZoneView()
                .environment(\.managedObjectContext, container.viewContext)
        }
    }
}
