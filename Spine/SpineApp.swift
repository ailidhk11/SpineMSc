//
//  SpineApp.swift
//  Spine
//
//  Created by Ailidh Kinney on 02/08/2022.
//

import SwiftUI
import Firebase

@main


struct spinev4App: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(ViewModel())
        }
    }
}
