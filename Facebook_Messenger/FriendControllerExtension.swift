//
//  FriendControllerExtension.swift
//  Facebook_Messenger
//
//  Created by Ikechukwu Michael on 25/01/2018.
//  Copyright © 2018 Ikechukwu Michael. All rights reserved.
//

import UIKit
import CoreData

extension FriendsViewController{
    
    func setUpData()  {
        // clear the database to store new objects
        clearData()
        
        // get the application delegate
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext{
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            
            // let mark = Friend()
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "zuckprofile"
            
            // let steve = Friend()
            let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context)as! Friend
            steve.name = "Steve Jobs"
            steve.profileImageName = "steve_profile"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = mark
            message.text = "Hey, are you hanging out tonight"
            message.date = NSDate()
            
            let messageSteve = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            messageSteve.friend = steve
            messageSteve.text = "I am on i cloud now"
            messageSteve.date = NSDate()
            // messages = [message, messageSteve]
            
            // save the object
            do { try context.save()
            }catch let err {
                print(err)
            }
            loadData()
        }
        
    }   // end of set up data function
    
    // create a function to load all the data in the database
    func loadData() {
         let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let fetch_request = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            do {
                messages = try context.fetch(fetch_request) as? [Message]
            }catch let err {
                print(err)
            }
            
        }
        
    
    }
    
    // delete or clear all data in the database to avoid duplicates
    func clearData()  {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
           
            do {
                let entityNames = ["Friend", "Message"]
                for entityName in entityNames{
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                    for object in objects!{ context.delete(object)}
                }
                try context.save()
            }catch let err {
                print(err)
            }
            
        }
        
    }
    
    
    

}
