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
            

            // let donald = Friend()
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context)as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "donald_trump_profile"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = mark
            message.text = "Hey Steve, I just got your message."
            message.date = NSDate()
            
            // add new friend Ghandi
            // let gandhi = Friend()
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context)as! Friend
            gandhi.name = "Mhatama Gandhi"
            gandhi.profileImageName = "gandhi"
            
            // add new friend Ghandi
            // let hillary = Friend()
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context)as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary_profile"
            
        
            FriendsViewController.createMessageWithText(text: "You are fired", friend: donald, context: context, minutesAgo: 8)
            FriendsViewController.createMessageWithText(text: "Live simple so others may simple live", friend: gandhi, context: context, minutesAgo: (60 * 24 ))
            FriendsViewController.createMessageWithText(text: "Please vote for me", friend: hillary, context: context, minutesAgo: (8 * 60 * 24 ))
            
            // call createSteve...message to add his messages
            createSteveMessagesWithContext(context: context)
            
            // save the object
            do { try context.save()
            }catch let err {
                print(err)
            }
            loadData()
        }
        
    }   // end of set up data function
    
    private func createSteveMessagesWithContext(context: NSManagedObjectContext){
        // let steve = Friend()
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context)as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        // messages = [message, messageSteve]
        
        FriendsViewController.createMessageWithText(text: "Good Morning!", friend: steve, context: context, minutesAgo: 5)
        FriendsViewController.createMessageWithText(text: "Do you want to sale Facebook? Hey Warren Buffet is upto something. Watch your back and wall street too",
                              friend: steve, context: context, minutesAgo: 3)
        FriendsViewController.createMessageWithText(text: "Call me when you get my message! What part of Rhode Islnad are you from. Get an uber and bring yourself down to Cappurtino", friend: steve, context: context, minutesAgo: 1)
        FriendsViewController.createMessageWithText(text: "Yes am back dude", friend: steve, context: context, minutesAgo: 1)
        FriendsViewController.createMessageWithText(text: "this is the 4th message.out going message for the blue bubble. Yes am back dude", friend: steve, context: context, minutesAgo: 0, isSender: true)
        FriendsViewController.createMessageWithText(text: "How much are you selling? lets meet at starbukcs",
                              friend: steve, context: context, minutesAgo: 0)
        FriendsViewController.createMessageWithText(text: "is fine by me", friend: steve, context: context, minutesAgo: 0, isSender: true)
        
    }
    
    // create a function to load all the data in the database
    func loadData() {
         let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            // get all friends
            if let friends = fetchFriends(){
                messages = [Message]()
                for friend in friends{
                    // print(friend.name!)
                    // let fetchedMessages:[Message]?
                    let fetch_request = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetch_request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetch_request.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetch_request.fetchLimit = 1
                    do {
                        let fetchedMessages = try context.fetch(fetch_request) as? [Message]
                        messages?.append(contentsOf: fetchedMessages!)
                    }catch let err {
                        print(err)
                    }
                    
                }
                // sort the messages to display according to time sent or delivered
                 messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
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
        
    }               // end of clear data function
    
    // create a function to insert new records to the database
    static func createMessageWithText(text:String, friend:Friend, context:NSManagedObjectContext, minutesAgo:Double, isSender: Bool=false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
        return message
    }
    
    // fetch all the friends messages
    private func fetchFriends()-> [Friend]?{
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let fetchFriendRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            do {
                return try context.fetch(fetchFriendRequest) as? [Friend]
            }catch let err {
                print(err)
            }
        }
        return nil
    }
    

}
