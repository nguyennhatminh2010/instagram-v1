//
//  NotificationController.swift
//  Instagram
//
//  Created by admin on 07/05/2021.
//

import UIKit

class NotificationController: UITableViewController {
    // MARK: - Properties
    let reuseIdentifier = "NotificationCell"
    private let refresh = UIRefreshControl()
    var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    // MARK: - API
    func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
            self.checkUserIsFollowed()
        }
    }
    
    func checkUserIsFollowed() {
        notifications.forEach { notification in
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id}) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        
        }
    }
    // MARK: - Helpers
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Nofitication"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
    
    }
    // MARK: Actions
    @objc func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresh.endRefreshing()
    }
}
// MARK: - UITableViewDatasource
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        let uid = notifications[indexPath.row].uid
        UserService.fetchUser(withUid: uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
// MARK: - UINotificationCellDelegate
extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFlowUser uid: String) {
        showLoader(true)
        UserService.follow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToUnflowUser uid: String) {
        showLoader(true)
        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        showLoader(true)
        PostService.fetchPost(with: postId, completion: { post in
            self.showLoader(false)
            let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            feedController.post = post
            self.navigationController?.pushViewController(feedController, animated: false)
        })
    }
    
    
}
