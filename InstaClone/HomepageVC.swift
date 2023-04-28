//
//  HomepageVC.swift
//  InstaClone
//
//  Created by Damla KS on 25.04.2023.
//

import UIKit
import Firebase
import SDWebImage

class HomepageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userMailArray = [String] ()
    var userImageArray = [String] ()
    var userCommentArray = [String] ()
    var likesArray = [Int] ()
    var documentIdArray = [String] ()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        
    }
    
    func getData() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { [self] snapshot, error in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                } else {
                    if snapshot?.isEmpty != true && snapshot != nil {
                        
                        userMailArray.removeAll(keepingCapacity: false)
                        userImageArray.removeAll(keepingCapacity: false)
                        userCommentArray.removeAll(keepingCapacity: false)
                        likesArray.removeAll(keepingCapacity: false)
                        documentIdArray.removeAll(keepingCapacity: false)
                        
                        for document in snapshot!.documents {
                            let documentID = document.documentID
                            documentIdArray.append(documentID)
                            
                            if let postedBy = document.get("postedBy") as? String {
                                userMailArray.append(postedBy)
                            }
                            
                            if let imageUrl = document.get("imageUrl") as? String {
                                userImageArray.append(imageUrl)
                            }
                            
                            if let postComment = document.get("postComment") as? String {
                                userCommentArray.append(postComment)
                            }
                            
                            if let likes = document.get("likes") as? Int {
                                likesArray.append(likes)
                            }
                        }
                        
                        tableView.reloadData()
                    }
                    
                }
            }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hCell", for: indexPath) as! HomepageCell
        cell.usermailLabel.text = userMailArray[indexPath.row]
        cell.userImage.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        cell.usercommentLabel.text = userCommentArray[indexPath.row]
        cell.likeLabel.text = String(likesArray[indexPath.row])
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
}
