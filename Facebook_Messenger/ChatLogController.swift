//
//  ChatLogController.swift
//  Facebook_Messenger
//
//  Created by Ikechukwu Michael on 25/01/2018.
//  Copyright © 2018 Ikechukwu Michael. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cellId = "cellId"
    var messages: [Message]?
    
    var friend: Friend? {
        didSet{
            friend?.name = navigationController?.title
            messages = friend?.messages?.allObjects as?[Message]
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        }
    }
    // add a container for entering text(chat)
    let messageInputContainerView: UIView = {
        let inputView = UIView()
        inputView.backgroundColor = .white
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    // create and add a textfield to the messageinputcontainerview
    let messageTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // add a send button to the messageinputcontainerview
    lazy var sendButton: UIButton = {
            let button = UIButton()
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 240/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogControllerCell.self, forCellWithReuseIdentifier: cellId)
        // hide the tab bar at the bottom of the view
        tabBarController?.tabBar.isHidden = true
        view.addSubview(messageInputContainerView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : messageInputContainerView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : messageInputContainerView]))
        setUpMessageInputView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotificiation(notification:)), name:  .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotificiation(notification:)), name:  .UIKeyboardWillHide, object: nil)
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
    }
    
    @objc private func handleKeyBoardNotificiation(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect)
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut,
                           animations: {
                            self.view.layoutIfNeeded()
                        }, completion: { (completed) in
                            if isKeyboardShowing {
                                let indexPath = IndexPath(item: self.messages!.count - 1, section: 0)
                                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                            }
                        })
        }
        
    }        // end of handlekeyboardnotification function
    
    // handle sendbutton function to update that database and charlogcontrollercell
    @objc func handleSendMessage() {
        //
        print("handle send text")
        // get the application delegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let newMessage = FriendsViewController.createMessageWithText(text: messageTextField.text!, friend: friend!, context: context, minutesAgo: 0, isSender: true)
        do {
            try context.save()
            messages?.append(newMessage)
            let item = messages!.count - 1
            let indexPath = IndexPath(item: item, section: 0)
            
            self.collectionView?.insertItems(at: [indexPath])
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            messageTextField.text = nil
        } catch let err {
       
            print(err)
        }
        
    }
    
    private func setUpMessageInputView(){
        messageInputContainerView.addSubview(messageTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0][v1(60)]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : messageTextField, "v1": sendButton]))
        messageInputContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : messageTextField]))
        messageInputContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : sendButton]))
    }
    

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        messageTextField.endEditing(true)
        print("end editing")
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = messages?.count != nil ? messages!.count : 0
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogControllerCell
        cell.messageTextView.text = messages?[indexPath.item].text
        
        if let message = messages?[indexPath.item], let messageText = message.text,  let profileImageName = message.friend?.profileImageName {
            cell.profileImageView.image = UIImage(named: profileImageName)
            let size  = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)], context: nil)
            if !message.isSender{
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textbubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6 )
                cell.profileImageView.isHidden = false
                // cell.textbubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
                cell.bubbleImageView.image = ChatLogControllerCell.greyBubbleImage
                cell.messageTextView.textColor = .black
            }else{
                // out going (send) messages
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textbubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20)
                cell.profileImageView.isHidden = true
                cell.bubbleImageView.image = ChatLogControllerCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = .white
            }
        
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let messageText = messages?[indexPath.item].text{
            let size  = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    

}

// create a custom cell of collectionView
class ChatLogControllerCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample Message"
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let textbubbleView: UIView = {
        let bubbleView = UIView()
        bubbleView.layer.cornerRadius = 15
        bubbleView.layer.masksToBounds = true
        // bubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return bubbleView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    static let greyBubbleImage = #imageLiteral(resourceName: "bubble_gray").resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = #imageLiteral(resourceName: "bubble_blue").resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    let bubbleImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            //imageView.image = #imageLiteral(resourceName: "bubble_gray").resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
            imageView.image = ChatLogControllerCell.greyBubbleImage
            imageView.tintColor = UIColor(white: 0.9, alpha: 1.0)
            return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(textbubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView]))
           addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView]))
        textbubbleView.addSubview(bubbleImageView)
        textbubbleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views:   ["v0" : bubbleImageView]))
        textbubbleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : bubbleImageView]))
        
        // backgroundColor = .lightGray
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(),
//                                                      metrics: nil, views: ["v0" : messageTextView]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(),
//                                                      metrics: nil, views: ["v0" : messageTextView]))
    }
    
    
}

