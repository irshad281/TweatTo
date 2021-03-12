//
//  User.swift
//  TweakTo.Test
//
//  Created by Irshad Ahmed on 11/03/21.
//

import Foundation
import CoreData

extension Collection where Iterator.Element == User {
    
    func save()->[Users]{
        var users = [Users]()
        
        self.forEach({
            let userObject = Users.init(entity: appDelegate.usersEntity, insertInto: viewContext)
            userObject.id = Int64($0.id ?? 0)
            userObject.login = $0.login
            userObject.avatar_url = $0.avatarURL
            appDelegate.saveContext()
            users.append(userObject)
        })
        
        return users
    }
}



extension Collection where Iterator.Element == Users {
    
    func fetch()->[Users]{
        let fetchRequest = NSFetchRequest<Users>.init(entityName: "Users")
        fetchRequest.fetchLimit  = 30
        fetchRequest.fetchOffset = self.count
        let list = try? viewContext.fetch(fetchRequest)
        return list ?? []
    }
    
    func mapToConfigurator()->[CellConfigurator] {
        var list = [CellConfigurator]()
        for (_, user) in self.enumerated() {
            var item:CellConfigurator!
            if user.notes != nil && user.notes != ""{
                item = NoteCellConfig.init(item: user)
            }else if Int64(user.id) % 4 == 1 {
                item = InvertedCellConfig.init(item: user)
            }else{
                item = UserCellConfig.init(item: user)
            }
            list.append(item)
        }
        return list
    }
}




class User: Codable {
    
    var login: String?
    var id: Int?
    var nodeID: String?
    var avatarURL: String?
    var gravatarID: String?
    var url, htmlURL, followersURL: String?
    var followingURL, gistsURL, starredURL: String?
    var subscriptionsURL, organizationsURL, reposURL: String?
    var eventsURL: String?
    var receivedEventsURL: String?
    var type: String?
    var siteAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }

}
