//
//  ViewModel.swift
//  Spine
//
//  Created by Ailidh Kinney on 22/07/2022.
//
import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import SDWebImageSwiftUI




class ViewModel: ObservableObject {
    
    
    @Published var list = [SpineBook]()
    @Published var currentlyReading = [SpineBook]()
    @Published var toBeRead = [SpineBook]()
    
    @Published var email = "" //Check if should be @State
    @Published var password = "" //Check if should be @State
    @Published var isUserLoggedIn = false
    @Published var userAccountStatusMessage = ""
    @Published var name = ""
    @Published var isCurRead = false
    @Published var isTbr = false
    
    
    
    
    
    init() {
        getBooks()
        getCurrentlyReading()
        getToBeRead()
    }
    
    func handleAddToCurrentlyReading(author: String, title: String, genre: String, cover: String, id: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(uid).collection("CurrentlyReading")

        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
        }

        ref.addDocument(data: ["author": author, "title" : title, "genre" : genre, "cover" : cover]) {error in
            if error != nil {
                print(error!.localizedDescription)

            }
        }
    }
    
    func handleAddToToBeRead(author: String, title: String, genre: String, cover: String, id: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(uid).collection("ToBeRead")
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
        }

        ref.addDocument(data: ["author": author, "title" : title, "genre" : genre, "cover" : cover]) {error in
            if error != nil {
                print(error!.localizedDescription)
                
            }
        }
    }
    

    
    func getBooks () {
        let db = Firestore.firestore()
        let ref = db.collection("SpineBooks")
        
        
        
        ref.getDocuments {snapshot, error in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                
                DispatchQueue.main.async { //what does this mean apart from syncing back to UI
                    self.list = snapshot.documents.map {d in
                        
                        return SpineBook(id: d.documentID,
                                         author: d["author"] as? String ?? "",
                                         genre: d["genre"] as? String ?? "",
                                         title: d["title"] as? String ?? "",
                                         cover: d["cover"] as? String ?? "")
                    }
                }
            }
            
        }
    }
    
    func getCurrentlyReading () {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(uid).collection("CurrentlyReading")
       

        
        ref.getDocuments {snapshot, error in

            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {

                DispatchQueue.main.async { //what does this mean apart from syncing back to UI
                    self.currentlyReading = snapshot.documents.map {d in

                        return SpineBook(id: d.documentID,
                                         author: d["author"] as? String ?? "",
                                         genre: d["genre"] as? String ?? "",
                                         title: d["title"] as? String ?? "",
                                         cover: d["cover"] as? String ?? "")
                    }
                }
            }

        }
    }
    
    func getToBeRead () {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(uid).collection("ToBeRead")
       
        ref.getDocuments {snapshot, error in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                
                DispatchQueue.main.async { //what does this mean apart from syncing back to UI
                    self.toBeRead = snapshot.documents.map {d in
                        
                        return SpineBook(id: d.documentID,
                                         author: d["author"] as? String ?? "",
                                         genre: d["genre"] as? String ?? "",
                                         title: d["title"] as? String ?? "",
                                         cover: d["cover"] as? String ?? "")
                    }
                }
            }
            
        }
    }
    
    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print("Incorrect info")
                self.userAccountStatusMessage = "Failed to create user"
            } else {
                self.isUserLoggedIn = true
                self.createUserAccount()
            }
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.isUserLoggedIn = false
                print(error!.localizedDescription)
                self.userAccountStatusMessage = "Incorrect email or password, please try again."
            } else {
                self.isUserLoggedIn = true
            }
            
        }
    }
    
    func createUserAccount() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        let userInfo = ["UserID" : uid, "Email": email, "Name": name]
        Firestore.firestore().collection("Users").document(uid).setData(userInfo) { error in
            if let error = error {
                print(error)
                return
            }
            else {
                print("Success")
            }
        }
    }
    
    func signOut() {
        isUserLoggedIn.toggle()
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("error signing out: %@", signOutError)
        }
    }
}

