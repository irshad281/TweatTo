//
//  UserTableCell.swift
//  TweakTo.Test
//
//  Created by Irshad Ahmed on 11/03/21.
//

import UIKit

class UserTableCell: UITableViewCell, ConfigurableCell {

    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var avatarImageView:ImageLoader!
    @IBOutlet weak var noteIndicator:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(data user: Users) {
        nameLabel.text = user.login
        if let path = user.avatar_url {
            avatarImageView.loadImageWithUrl(path, completion: nil)
        }
    }
    
}




class InvertedTableCell: UITableViewCell, ConfigurableCell {

    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var avatarImageView:ImageLoader!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(data user: Users) {
        nameLabel.text = user.login
        if let path = user.avatar_url {
            avatarImageView.loadImageWithUrl(path) { (image) in
                self.avatarImageView.image = image?.inverted()
            }
        }
    }
    
}





class NotedTableCell: UITableViewCell, ConfigurableCell {

    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var avatarImageView:ImageLoader!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(data user: Users) {
        nameLabel.text = user.login
        if let path = user.avatar_url {
            avatarImageView.loadImageWithUrl(path, completion: nil)
        }
    }
    
}
