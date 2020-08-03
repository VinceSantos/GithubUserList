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
    func fetchGitUsers(id: Int, completion: @escaping() -> Void) {
        let url = URL(string: "https://api.github.com/users?since=\(id.description)")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                let fetchedList = try JSONDecoder().decode([UserListModel].self, from: data)
                print(fetchedList.count)
                DispatchQueue.main.async {
                    guard let appDelegate =
                      UIApplication.shared.delegate as? AppDelegate else {
                      return
                    }
                    
                    // 1
                    let managedContext =
                      appDelegate.persistentContainer.viewContext
                    
                    let fetchRequest =
                      NSFetchRequest<NSManagedObject>(entityName: "UserList")
                    
                    do {
                        let result = try managedContext.fetch(fetchRequest)
                        if result.isEmpty {
                            for item in fetchedList {
                                self.syncToLocal(fetchedList: item)
                            }
                            self.dispatchGroup.notify(queue: .main) {
                               self.getLocal()
                               completion()
                            }
                        } else {
                            self.getLocal()
                            completion()
                        }
                    } catch let error as NSError {
                      print("Could not fetch. \(error), \(error.userInfo)")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func syncToLocal(fetchedList: UserListModel) {
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
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "UserList")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let isExisting = result.contains(where: {($0.value(forKey: "id") as! Int) == fetchedList.id})
            if !isExisting {
                let url = URL(string: fetchedList.avatar_url)!

                URLSession.shared.dataTask(with: url) {(data, response, error) in
                    guard let data = data else { return }
                    user.setValue(data, forKey: "avatar")
                    user.setValue(fetchedList.avatar_url, forKeyPath: "avatar_url")
                    user.setValue(fetchedList.id, forKeyPath: "id")
                    user.setValue(fetchedList.login, forKeyPath: "login")
                    user.setValue(fetchedList.repos_url, forKeyPath: "repos_url")
                    user.setValue(false, forKey: "hasNote")
                    do {
                        try managedContext.save()
                        self.dispatchGroup.leave()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }.resume()
            } else {
                self.dispatchGroup.leave()
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getLocal() {
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
            var resultingData = [UserViewModel]()
            for data in result {
                resultingData.append(UserViewModel(id: data.value(forKey: "id") as! Int, login: data.value(forKey: "login") as! String, repos_url: data.value(forKey: "repos_url") as! String, avatar: UIImage(data: data.value(forKey: "avatar") as! Data, scale: 0.5)!, hasNote: data.value(forKey: "hasNote") as? Bool ?? false))
            }
            self.userList = resultingData
            print(self.userList.count)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func search(criteria: String, completion: @escaping([UserViewModel]) -> Void) {
        let filteredData = self.userList.filter{ $0.login.contains(criteria)}
        completion(filteredData)
    }
}

struct UserViewModel {
    var id: Int
    var login: String
    var repos_url: String
    var avatar: UIImage
    var hasNote: Bool
}
