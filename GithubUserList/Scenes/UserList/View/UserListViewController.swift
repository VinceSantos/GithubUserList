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
    private var currentLastIndex = 0
    private var isDownloading = false
    private var isSearching = false

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
        fetchAvailableData()
    }
    
    //MARK: Setup
    private func setupUI() {
        setupNavigationBar()
        setupTableView()
    }

    private func setupBindings() {
        viewModel = UserListViewModel()
        fetchAvailableData()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        let searchTextfield = UISearchBar()
        searchTextfield.delegate = self
        self.navigationItem.titleView = searchTextfield
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: UserListTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserListTableViewCell.self))
    }
    
    //MARK: Actions
    func startIndicator() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        activityIndicator.show(uiView: self)
        isDownloading = true
        self.tableView.isUserInteractionEnabled = false
    }
    
    func stopIndicator() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        isDownloading = false
        self.tableView.isUserInteractionEnabled = true
        activityIndicator.stop(uiView: self)
    }
    
    func fetchAvailableData() {
        self.startIndicator()
        viewModel.fetchData(id: currentLastIndex, isPaginated: false, currentList: []) { (userData) in
            self.stopIndicator()
            if !userData.isEmpty {
                self.githubUserList = userData
                self.tableView.reloadData()
            }
        }
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.githubUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserListTableViewCell.self)) as! UserListTableViewCell
        cell.gitUserName.text = self.githubUserList[indexPath.row].login
        cell.details.text = "details"
        cell.gitImage.image = UIImage(data: self.githubUserList[indexPath.row].avatar!) ?? UIImage(named: "user")
        let absoluteRow = indexPath.row + 1
        if absoluteRow.isMultiple(of: 4) {
            cell.gitImage.image = cell.gitImage.image?.invertedImage()
        }
        if self.githubUserList[indexPath.row].hasNote {
            cell.noteImage.isHidden = false
        } else {
            cell.noteImage.isHidden = true
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.githubUserList.count && !isDownloading && !isSearching{
            self.startIndicator()
            viewModel.fetchData(id: (self.githubUserList.last?.id)!, isPaginated: true, currentList: self.githubUserList) { (userData) in
                self.stopIndicator()
                if !userData.isEmpty {
                    self.githubUserList = userData
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(identifier: String(describing: ProfileViewController.self)) as! ProfileViewController
        destinationVC.gitUser = self.githubUserList[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            fetchAvailableData()
        } else {
            isSearching = true
            let filteredData = self.githubUserList.filter { data in
                return (data.login?.contains(searchText.lowercased()))!
            }
            self.githubUserList = filteredData
            self.tableView.reloadData()
        }
    }
}
