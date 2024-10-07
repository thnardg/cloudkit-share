//
//  ShareController.swift
//  ShareDataViaCloudKit
//
//  Created by Thayna Rodrigues on 02/10/24.
//

import CloudKit
import Foundation
import SwiftUI
import UIKit

struct CloudSharingView: UIViewControllerRepresentable {
    let share: CKShare
    let container: CKContainer
    let room:Room

    func makeCoordinator() -> CloudSharingCoordinator {
        CloudSharingCoordinator.shared
    }

    func makeUIViewController(context: Context) -> UICloudSharingController {
        share[CKShare.SystemFieldKey.title] = room.name
        share.publicPermission = .readWrite
        let controller = UICloudSharingController(share: share, container: container)
        controller.modalPresentationStyle = .formSheet
        controller.delegate = context.coordinator
        context.coordinator.room = room
        return controller
    }

    func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {

    }
}

class CloudSharingCoordinator:NSObject,UICloudSharingControllerDelegate{
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("failed to save share\(error)")
    }

    func itemTitle(for csc: UICloudSharingController) -> String? {
        room?.name
    }

    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController){
        
    }

    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController){

        guard let room = room else {return}
        if !stack.isOwner(object: room) {
            stack.deleteRoom(room)
        }
        else {
            // lidar com a lógica de quando parar de compartilhar aqui
        }
    }
    
    func countParticipants(for share: CKShare) -> Bool {
        return share.participants.count >= 2
    }
    
    
    static let shared = CloudSharingCoordinator()
    let stack = CoreDataStack.shared
    var room:Room?
}


