//
//  ViewModel.swift
//  FireApp
//
//  Created by Darran Shivdat on 3/11/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase
class ViewModel: ObservableObject {
    @Published var list = [Cars]()
    
    
    func updateData(carsToUpdate: Cars) {
        let db = Firestore.firestore()
        db.collection("cars").document(carsToUpdate.id).setData(["make": "Updated:\(carsToUpdate.make)", "model": "Updated:\(carsToUpdate.model)", "mods": "Updated:\(carsToUpdate.mods)"], merge: true) { error in
            if error == nil {
                self.getData()
            }
        }
    }
    
    
    
    func deleteData(carsToDelete: Cars) {
        let db = Firestore.firestore()
        db.collection("cars").document(carsToDelete.id).delete { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.list.removeAll { car in
                        return car.id == carsToDelete.id
                    }
                }
            }
        }
    }
    
    func addData(make: String, model: String, mods: String) {
        let db = Firestore.firestore()
        db.collection("cars").addDocument(data: ["make": make, "model": model, "mods":mods]) { error in
            if error == nil {
                self.getData()
            }
        }
    }
    
    func getData() {
        
        let db = Firestore.firestore()
        db.collection("cars").getDocuments { DataSnapshot, error in
            if error == nil {
                if let DataSnapshot = DataSnapshot{
                    DispatchQueue.main.async {
                        self.list = DataSnapshot.documents.map { d in
                            return Cars(id: d.documentID,
                                        make: d["make"] as? String ?? "",
                                        model: d["model"] as? String ?? "",
                                        mods: d["mods"] as? String ?? "")
                            
                        }
                    }
                }
            }
           
        }
    }
    
    
}
