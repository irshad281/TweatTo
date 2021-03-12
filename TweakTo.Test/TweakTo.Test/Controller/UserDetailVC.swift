//
//  UserDetailVC.swift
//  TweakTo.Test
//
//  Created by Irshad Ahmed on 11/03/21.
//

import UIKit

class UserDetailVC: UIViewController {
    
    @IBOutlet weak var imageView:ImageLoader!
    
    @IBOutlet weak var followerLabel:UILabel!
    @IBOutlet weak var followingLabel:UILabel!
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var companyLabel:UILabel!
    @IBOutlet weak var blogLabel:UILabel!
    @IBOutlet weak var notesTextView:KMPlaceholderTextView!
    
    
    var user:Users?
    
    var userDetails:UserDetails?{
        didSet{
            setData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUserDetails()
    }
    
    func fetchUserDetails() {
        
        guard let username = user?.login else {return}
        
        UserServiceAPI.shared.fetchUserDetail(username: username) { (result: Result<UserDetails, UserServiceAPI.APIServiceError>) in
            
            switch result {
            case .success(let details):
                self.userDetails = details
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    func setData() {
        
        if let name = userDetails?.name {
            nameLabel.text = "Name: \(name)"
        }
        
        if let path = user?.avatar_url {
            imageView.loadImageWithUrl(path, completion: nil)
        }
        
        if let follower = userDetails?.followers {
            followerLabel.text = "Follower: \(follower)"
        }
        
        if let following = userDetails?.following {
            followingLabel.text = "Follower: \(following)"
        }
        
        if let company = userDetails?.company {
            companyLabel.text = "Company: \(company)"
        }
        
        if let blog = userDetails?.blog {
            blogLabel.text = "Blog: \(blog)"
        }
        
        notesTextView.text = user?.notes
    }
    
}





extension UserDetailVC {
    
    @IBAction func clickOnSave() {
        self.user?.notes = notesTextView.text
        appDelegate.saveContext()
    }
}
