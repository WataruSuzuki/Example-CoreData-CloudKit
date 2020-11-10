//
//  CloudKitCoreDataApp.swift
//  Shared
//
//  Created by 鈴木航 on 2020/12/04.
//

import SwiftUI

@main
struct CloudKitCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
