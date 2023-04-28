//
//  HomepageCell.swift
//  InstaClone
//
//  Created by Damla KS on 28.04.2023.
//

import UIKit
import Firebase

class HomepageCell: UITableViewCell {
    
    @IBOutlet weak var usermailLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usercommentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) {
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            firestoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
    }
    
}
