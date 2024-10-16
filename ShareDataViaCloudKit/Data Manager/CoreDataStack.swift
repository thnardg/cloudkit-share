//
//  CoreDataStack.swift
//  ShareDataViaCloudKit
//
//  Created by Thayna Rodrigues on 02/10/24.
//

import CloudKit
import CoreData
import Foundation

final class CoreDataStack {
    static let shared = CoreDataStack()

    init() {}

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Model")

        let dbURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let privateDesc = NSPersistentStoreDescription(url: dbURL.appendingPathComponent("model.sqlite"))
        privateDesc.configuration = "Private"
        privateDesc.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: ckContainerID)
        privateDesc.cloudKitContainerOptions?.databaseScope = .private

        guard let shareDesc = privateDesc.copy() as? NSPersistentStoreDescription else {
            fatalError("Create shareDesc error")
        }
        shareDesc.url = dbURL.appendingPathComponent("share.sqlite")
        let shareDescOption = NSPersistentCloudKitContainerOptions(containerIdentifier: ckContainerID)
        shareDescOption.databaseScope = .shared
        shareDesc.cloudKitContainerOptions = shareDescOption

        container.persistentStoreDescriptions = [privateDesc, shareDesc]

        container.loadPersistentStores(completionHandler: { desc, err in
            if let err = err as NSError? {
                fatalError("DB init error:\(err.localizedDescription)")
            } else if let cloudKitContiainerOptions = desc.cloudKitContainerOptions {
                switch cloudKitContiainerOptions.databaseScope {
                case .private:
                    self._privatePersistentStore = container.persistentStoreCoordinator.persistentStore(for: privateDesc.url!)
                case .shared:
                    self._sharedPersistentStore = container.persistentStoreCoordinator.persistentStore(for: shareDesc.url!)
                default:
                    break
                }
            }
        })

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("Fail to pin viewContext to the current generation:\(error)")
        }

        return container
    }()

    let ckContainerID = "iCloud.com.thayna.SwiftUIShareData"

    var ckContainer: CKContainer {
        CKContainer(identifier: ckContainerID)
    }

    private var _privatePersistentStore: NSPersistentStore?
    var privatePersistentStore: NSPersistentStore {
        return _privatePersistentStore!
    }

    private var _sharedPersistentStore: NSPersistentStore?
    var sharedPersistentStore: NSPersistentStore {
        return _sharedPersistentStore!
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}


// MARK: -- SALVAR NO CORE DATA
extension CoreDataStack {
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("ViewContext save error:\(error)")
            }
        }
    }
}
