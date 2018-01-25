//
//  ViewController.swift
//  Facebook_Messenger
//
//  Created by Ikechukwu Michael on 25/01/2018.
//  Copyright © 2018 Ikechukwu Michael. All rights reserved.
//

import UIKit

class FriendsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellId = "cellId"
    
    var messages: [Message]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView?.backgroundColor = .white
        navigationController?.title = "Recent"
        collectionView?.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        setUpData()
    }
    
    func setUpData()  {
        let mark = Friend()
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "zuckprofile"
        
        let steve = Friend()
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        
        let message = Message()
        message.friend = mark
        message.text = "Hey, are you hanging out tonight"
        message.date = NSDate()
        
        let messageSteve = Message()
        messageSteve.friend = steve
        messageSteve.text = "I am on i cloud now"
        messageSteve.date = NSDate()
        messages = [message, messageSteve]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let count =  messages?.count  {
//            return count
//        }
//        return 0
        let count = messages?.count != nil ? messages!.count : 0
        return count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FriendCollectionViewCell
        if let message = messages?[indexPath.item]{
            cell.message = message
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
 

}

