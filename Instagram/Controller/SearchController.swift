//
//  SearchController.swift
//  Instagram
//
//  Created by admin on 07/05/2021.
//

import UIKit

class SearchController: UITableViewController {
    // MARK: - Properties
    
    let reuseIdentifier = "UserCell"
    private var users = [User]()
    private var filteredUsers = [User]()
    private var searchController = UISearchController(searchResultsController: nil)
    private var isSearching: Bool {
        return !searchController.searchBar.text!.isEmpty && searchController.isActive
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureTableView()
        fetchUsers()
    }
    // MARK: - API
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    // MARK: - Helpers
    func configureTableView() {
        view.backgroundColor = .white
        tableView.rowHeight = 64
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}
// MARK: - UITableViewDataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.userViewModel = UserCellViewModel(user: user)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        let profileItem = ProfileController(user: user)
        navigationController?.pushViewController(profileItem, animated: false)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({ $0.username.lowercased().contains(searchText) ||                                 $0.fullname.lowercased().contains(searchText)})
        self.tableView.reloadData()
    }
    
    
}
