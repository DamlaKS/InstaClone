//
//  UploadVC.swift
//  InstaClone
//
//  Created by Damla KS on 25.04.2023.
//

import UIKit
import PhotosUI
import Firebase
import FirebaseStorage

class UploadVC: UIViewController, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureRecognizer()
    }
    
    func addTapGestureRecognizer() {
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func chooseImage() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        
        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let selectedImage = results.first?.itemProvider else { return }
        selectedImage.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self else { return }
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            } else if let image = image as? UIImage {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.shareButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("Media")
        let uuid = UUID().uuidString
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            let firestoreDatabase = Firestore.firestore()
                            //var firestoreReference: DocumentReference
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { [self] (error) in
                                if error != nil {
                                    makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    imageView.image = UIImage(named: "select")
                                    commentText.text = ""
                                    tabBarController?.selectedIndex = 0
                                }
                                
                            } )
                        }
                    }
                }
            }
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    /*
     func timeString() -> String {
     let now = Date()
     let formatter = ISO8601DateFormatter()
     let datetime = formatter.string(from: now)
     print(datetime)
     return datetime
     }
     */
    
}
