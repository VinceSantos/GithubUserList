//
//  Profile module - ProfileViewController.swift
//  GithubUserList
//
//  Created by Vince Santos on 02/08/2020.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    public var viewModel: ProfileViewModel!
    public var gitUser: UserViewModel!
    private var userProfile: ProfileModel?
    private var activityIndicator = ActivityIndicator()
    private var textfieldText = ""

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    private func setupUI() {
        setupTableView()
    }

    private func setupBindings() {
        viewModel = ProfileViewModel()
        self.activityIndicator.show(uiView: self)
        viewModel.fetchProfileData(userName: gitUser.login!) {
            self.userProfile = self.viewModel.profileData
            self.title = self.userProfile?.name
            self.tableView.reloadData()
            self.activityIndicator.stop(uiView: self)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: ProfileHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProfileHeaderTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ProfileInformationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProfileInformationTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ProfileNoteTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProfileNoteTableViewCell.self))
    }
    
    @objc func updateNoteCoreData() {
        viewModel.updateNote(id: self.gitUser.id!, noteString: textfieldText) {
            self.userProfile = self.viewModel.profileData
            self.tableView.reloadData()
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileHeaderTableViewCell.self)) as! ProfileHeaderTableViewCell
            cell.profileHeader.image = UIImage(data: self.gitUser.avatar!)
            cell.profileFollowers.text = "Followers: \(self.userProfile?.followers?.description ?? "0")"
            cell.profileFollowing.text = "Following: \(self.userProfile?.following?.description ?? "0")"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileInformationTableViewCell.self)) as! ProfileInformationTableViewCell
            cell.profileInfomationLabel.text = "Name: \(self.userProfile?.name ?? "")\n\nCompany: \(self.userProfile?.company ?? "")\n\nBlog: \(self.userProfile?.blog ?? "")\n\nBio: \(self.userProfile?.bio ?? "")"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileNoteTableViewCell.self)) as! ProfileNoteTableViewCell
            cell.noteTextView.delegate = self
            cell.noteTextView.text = self.userProfile?.note
            cell.saveButton.addTarget(self, action: #selector(updateNoteCoreData), for: .touchUpInside)
            return cell
        }
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textfieldText = textView.text
    }
}
