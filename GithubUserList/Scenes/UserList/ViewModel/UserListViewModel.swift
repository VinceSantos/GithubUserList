//
//  UserList module - UserListViewModel.swift
//  GithubUserList
//
//  Created by Vince Santos on 31/07/2020.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit
import CoreData

class UserListViewModel {
    var userList: [UserViewModel] = []
    let dispatchGroup = DispatchGroup()
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    // MARK: - Data
    func fetchData(id: Int, completion: @escaping ([UserViewModel]) -> Void) {
        //1
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "UserList")
        
        //3
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.isEmpty {
                getUserList(id: id) { (data) in
                    completion(data)
                }
            } else {
                completion([UserViewModel]())
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getUserList(id: Int, completion: @escaping ([UserViewModel]) -> Void) {
        if let validUrl = URL(string: "\(Constants.url)\(id)") {
            URLSession.shared.dataTask(with: validUrl) { (data, response, error) in
                if let validData = data {
                    do {
                        let userList = try JSONDecoder().decode([UserListModel].self, from: validData)
                        var userViewList = [UserViewModel]()
                        for item in userList {
                            self.dispatchGroup.enter()
                            if let imageStringUrl = item.avatar_url {
                                if let imageUrl = URL(string: imageStringUrl) {
                                    URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                                        userViewList.append(UserViewModel(id: item.id, login: item.login, repos_url: item.repos_url, avatar: data, hasNote: false))
                                        self.dispatchGroup.leave()
                                    }.resume()
                                }
                            } else {
                                userViewList.append(UserViewModel(id: item.id, login: item.login, repos_url: item.repos_url, avatar: UIImage(named: "user")?.pngData(), hasNote: false))
                                self.dispatchGroup.leave()
                            }
                        }
                        self.dispatchGroup.notify(queue: .main) {
                            completion(userViewList)
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

struct UserViewModel {
    var id: Int?
    var login: String?
    var repos_url: String?
    var avatar: Data?
    var hasNote: Bool
}
