//
//  Profile module - ProfileViewModel.swift
//  GithubUserList
//
//  Created by Vince Santos on 02/08/2020.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewModel {
    var profileData: ProfileModel!
    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Data
        func fetchProfileData(userName: String, completion: @escaping() -> Void) {
            let url = URL(string: "https://api.github.com/users/\(userName)")!

            URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                do {
                    let fetchedList = try JSONDecoder().decode(ProfileModel.self, from: data)
                    DispatchQueue.main.async {
                        self.syncToLocal(profile: fetchedList) {
                            completion()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    
    func syncToLocal(profile: ProfileModel, completion: @escaping() -> Void) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
          NSEntityDescription.entity(forEntityName: "Profile",
                                     in: managedContext)!
        
        let user = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Profile")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let isExisting = result.contains(where: {($0.value(forKey: "id") as! Int) == profile.id})
            print("is Existing --- \(isExisting)")
            if !isExisting || result.isEmpty {
                // 3
                user.setValue(profile.id, forKey: "id")
                user.setValue(profile.name, forKeyPath: "name")
                user.setValue(profile.company, forKeyPath: "company")
                user.setValue(profile.blog, forKeyPath: "blog")
                user.setValue(profile.bio, forKeyPath: "bio")
                user.setValue(profile.followers, forKey: "followers")
                user.setValue(profile.following, forKey: "following")
                
                // 4
                do {
                    try managedContext.save()
                    self.profileData = profile
                    print("added to coredata: \(user)")
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            } else {
                let predicate = NSPredicate(format: "id = %@", "\(profile.id ?? 0)")
                fetchRequest.predicate = predicate
                
                do {
                    let tasks = try managedContext.fetch(fetchRequest)
                    let task = tasks.first
                    let profileFetch = ProfileModel(id: task!.value(forKey: "id") as? Int, name: task!.value(forKey: "name") as? String, company: task!.value(forKey: "company") as? String, blog: task!.value(forKey: "blog") as? String, bio: task!.value(forKey: "bio") as? String, followers: task!.value(forKey: "followers") as? Int, following: task!.value(forKey: "following") as? Int, note: task!.value(forKey: "note") as? String)
                    self.profileData = profileFetch
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            completion()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateNote(id: Int, noteString: String, completion: @escaping() -> Void) {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Profile")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        if !noteString.isEmpty {
            do
            {
                let test = try managedContext.fetch(fetchRequest)
                
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(noteString, forKey: "note")
                
                do{
                    try managedContext.save()
                    updateUserListNote(id: id) {
                        completion()
                    }
                }
                catch
                {
                    print(error)
                }
            }
            catch
            {
                print(error)
            }
        }
    }
    
    func updateUserListNote(id: Int, completion: @escaping() -> Void) {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UserList")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(true, forKey: "hasNote")
            
            do{
                try managedContext.save()
                self.syncToLocal(profile: self.profileData) {
                    completion()
                }
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
}
