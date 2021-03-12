//
//  UserListVC.swift
//  TweakTo.Test
//
//  Created by Irshad Ahmed on 11/03/21.
//

import UIKit

class UserListVC: UITableViewController {
    
    var users = [Users](){didSet{tableView.reloadData()}}
    var filteredUsers = [Users]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearhing = false

    var userViewModel = UserViewModel()
    var filteredViewModel = UserViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Search Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        observerNetwork()
        
        users = users.fetch()
        userViewModel.list.append(contentsOf: users.mapToConfigurator())
        if users.count == 0 {
            fetchUsersFromGitHub()
        }
    }
    

    // Monitor Network Connection
    func observerNetwork() {
        
        let reachability = try? Reachability.init(hostname: "google.com")
        try? reachability?.startNotifier()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .unavailable {
            print("No Connected")
        } else {
            print("Connected")
        }
    }
    
    
    func fetchUsersFromGitHub() {
        
        let since = Double(users.last?.id ?? 0)
        tableView.tableFooterView = since == 0 ? nil : loader
        
        UserServiceAPI.shared.fetchUserList(since: Double(since)) { (result: Result<[User], UserServiceAPI.APIServiceError>) in
            self.tableView.tableFooterView = nil
            switch result {
            case .success(let users):
                self.userViewModel.list.append(contentsOf: users.save().mapToConfigurator())
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}






// MARK: - Table view data source
extension UserListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearhing == true ? filteredViewModel.list.count : userViewModel.list.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = isSearhing == true ? filteredViewModel.list[indexPath.row] : userViewModel.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: data).reuseId)!
        data.configure(cell: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearhing == true ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        vc.user = user
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isSearhing {return}
        guard scrollView.shouldPaginate() == true else {return}
        if users.fetch().count == 0 {
            fetchUsersFromGitHub()
        }else{
            let nextPageData = users.fetch()
            self.users.append(contentsOf: nextPageData)
            self.userViewModel.list.append(contentsOf: nextPageData.mapToConfigurator())
            self.tableView.reloadData()
        }
    }
}






extension UserListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        if text == "" {isSearhing = false;tableView.reloadData();return}
        isSearhing = true
        filteredUsers = users.filter({$0.login!.localizedCaseInsensitiveContains(text)})
        self.filteredViewModel.list = filteredUsers.mapToConfigurator()
        tableView.reloadData()
    }
}
