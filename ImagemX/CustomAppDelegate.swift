//  CustomAppDelegate.swift
//  ImagemX
//
//  Created by Pedro Santos on 21/10/25.
//

import UserNotifications
import SwiftUI
import CloudKit


let subscriptionID = "NotificaSurpresa"

class CustomAppDelegate: NSObject, UIApplicationDelegate {

    var app: ImagemXApp?

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
         didReceive response: UNNotificationResponse) async {
        
        print("Notificação recebida com o título: \(response.notification.request.content.title)")
        
        if response.notification.request.content.title == "Surpresa" {
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .showSurpresa, object: nil)
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification)
        async -> UNNotificationPresentationOptions {

        return [.badge, .banner, .list, .sound]
    }


}

func dispararSurpresa() {
    let subscription = CKQuerySubscription(
        recordType: "Surpresa",
        predicate: NSPredicate(value: true),
        subscriptionID: subscriptionID,
        options: .firesOnRecordCreation
    )

    let notificationInfo = CKSubscription.NotificationInfo()
    notificationInfo.title = "Surpresa"
    notificationInfo.alertBody = "Clique para ver a surpresa"
    notificationInfo.shouldBadge = true
    notificationInfo.soundName = "default"

    subscription.notificationInfo = notificationInfo

    CKContainer.default().publicCloudDatabase.save(subscription) { savedSubscription, error in
        if let error = error {
            print("Erro ao criar inscrição (ou ela já existe): \(error.localizedDescription)")
        } else {
            print("Inscrição criada com sucesso!")
        }
    }
     
    let record = CKRecord(recordType: "Surpresa")
    
    record["mensagem"] = "Esta é a surpresa!"

    CKContainer.default().publicCloudDatabase.save(record) { _, error in
        if let error = error {
            print("Erro ao salvar record: \(error)")
        } else {
            print("Record 'Surpresa' criado, subscrição deve disparar push!")
        }
    }
}
