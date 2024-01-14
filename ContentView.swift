//
//  ContentView.swift
//  FireApp
//
//  Created by Darran Shivdat on 3/8/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct ContentView: View {
    @ObservedObject var vmodel = ViewModel()
    @State var make = ""
    @State var model = ""
    @State var mods = ""
    
    @State var isPick = false
    @State var selectedImage: UIImage?
    var body: some View {
        VStack {
            List(vmodel.list) { item in
                HStack {
                    Text(item.make)
                    Spacer()
                    
                    
                    Button(action: {
                        vmodel.updateData(carsToUpdate: item)
                    }, label: {
                        Image(systemName: "pencil")
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
                    
                    Button(action: {
                        vmodel.deleteData(carsToDelete: item)
                    }, label: {
                        Image(systemName: "minus.circle")
                    })
                    .buttonStyle(BorderedButtonStyle())
                }
            }
            if selectedImage != nil{
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
           
            HStack {
                Button {
                    isPick = true
                } label: {
                    Text("Select a photo")
                }
                if selectedImage != nil {
                    Button {
                        uploadPhoto()
                    } label: {
                        Text("Upload Photo")
                    }

                }
                
            }
            .sheet(isPresented: $isPick, onDismiss: nil) {
                ImagePicker(selectedImage: $selectedImage, isPick: $isPick)
            }
            VStack(spacing: 5) {
                TextField("Make", text: $make)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Model", text: $model)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Mods", text: $mods)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            
            Button(action : {
                vmodel.addData(make: make, model: model, mods: mods)
                make = ""
                model = ""
                mods = ""
            },label: {
                Text("Add your car!")
            })
            Divider()
            
        }
    }
    
    init() {
        vmodel.getData()
    }
    
    func uploadPhoto() {
        
        guard selectedImage != nil else {
            return
        }
        let storageRef = Storage.storage().reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.5)
        guard imageData != nil else {
            return
        }
        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
