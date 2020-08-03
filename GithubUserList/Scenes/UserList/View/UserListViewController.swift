//
//  UserList module - UserListViewController.swift
//  GithubUserList
//
//  Created by Vince Santos on 31/07/2020.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    public var viewModel: UserListViewModel!
    private var githubUserList = [UserViewModel]()
    private var activityIndicator = ActivityIndicator()

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    //MARK: Setup
    private func setupUI() {
        stopIndicator()
        setupNavigationBar()
        setupTableView()
    }

    private func setupBindings() {
        viewModel = UserListViewModel()
        startIndicator()
        viewModel.fetchGitUsers(id: 0) {
            self.githubUserList = self.viewModel.userList
            self.tableView.reloadData()
            self.stopIndicator()
        }
    }
    
    private func setupNavigationBar() {
        //cleaners
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let searchTextfield = UISearchBar()
        self.navigationItem.titleView = searchTextfield
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: UserListTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserListTableViewCell.self))
    }
    
    //MARK: Actions
    @objc func fetchMoreUsers() {
        startIndicator()
        viewModel.fetchGitUsers(id: githubUserList.last!.id) {
            self.githubUserList = self.viewModel.userList
            self.tableView.reloadData()
            self.stopIndicator()
        }
    }
    
    func startIndicator() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        activityIndicator.show(uiView: self)
    }
    
    func stopIndicator() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        activityIndicator.stop(uiView: self)
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.githubUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserListTableViewCell.self)) as! UserListTableViewCell
        cell.gitUserName.text = self.githubUserList[indexPath.row].login
        cell.details.text = "User Repository URL: \(self.githubUserList[indexPath.row].repos_url)"
        cell.gitImage.image = self.githubUserList[indexPath.row].avatar
        let absoluteRow = indexPath.row + 1
        if absoluteRow.isMultiple(of: 4) {
            cell.gitImage.image = self.githubUserList[indexPath.row].avatar.invertedImage()
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == self.githubUserList.count {
//            fetchMoreUsers()
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(identifier: String(describing: ProfileViewController.self)) as! ProfileViewController
        destinationVC.gitUser = self.githubUserList[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
