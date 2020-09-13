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
    func fetchData(id: Int, isPaginated: Bool, currentList: [UserViewModel]?, completion: @escaping ([UserViewModel]) -> Void) {
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
                    let sortedData = data.sorted()
                    for item in sortedData {
                        self.syncToLocal(fetchedList: item)
                    }
                    self.dispatchGroup.notify(queue: .main) {
                        completion(sortedData)
                    }
                }
            } else {
                if !currentList!.isEmpty && isPaginated {
                    getUserList(id: id) { (data) in
                        let sortedData = data.sorted()
                        for item in sortedData {
                            self.syncToLocal(fetchedList: item)
                        }
                        self.dispatchGroup.notify(queue: .main) {
                            self.getLocal { (data) in
                                completion(data)
                            }
                        }
                    }
                } else {
                    getLocal { (data) in
                        completion(data)
                    }
                }
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
    
    func syncToLocal(fetchedList: UserViewModel) {
        self.dispatchGroup.enter()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserList",
                                       in: managedContext)!
        
        let user = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        user.setValue(fetchedList.avatar, forKey: "avatar")
        user.setValue(fetchedList.id, forKeyPath: "id")
        user.setValue(fetchedList.login, forKeyPath: "login")
        user.setValue(false, forKey: "hasNote")
        do {
            try managedContext.save()
            self.dispatchGroup.leave()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getLocal(completion: @escaping ([UserViewModel]) -> Void) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "UserList")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            var resultingData = [UserViewModel]()
            for data in result {
                resultingData.append(UserViewModel(id: data.value(forKey: "id") as? Int, login: data.value(forKey: "login") as? String, repos_url: "", avatar: data.value(forKey: "avatar") as? Data, hasNote: data.value(forKey: "hasNote") as? Bool ?? false))
            }
            completion(resultingData)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

struct UserViewModel: Comparable {
    static func < (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        lhs.id! < rhs.id!
    }
    
    var id: Int?
    var login: String?
    var repos_url: String?
    var avatar: Data?
    var hasNote: Bool
}
