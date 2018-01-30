//
//  FriendCollectionViewCell.swift
//  Facebook_Messenger
//
//  Created by Ikechukwu Michael on 25/01/2018.
//  Copyright © 2018 Ikechukwu Michael. All rights reserved.
//

import UIKit

class FriendCollectionViewCell: BaseCell {
    
    // set the color of each cell when highlighted
    override var isHighlighted: Bool{
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1.0) : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            messageLabel.textColor = isHighlighted ? .white : .black
            timeLabel.textColor = isHighlighted ? .white : .black
        }
    }
    
    
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            messageLabel.text = message?.text
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
           
            // set the time label with the time of message sent
            if let date = message?.date {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                let elapsedTimeInSeconds = Date().timeIntervalSince(date as Date)
                
                let secondInDays: TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > 7 * secondInDays {
                    dateFormatter.dateFormat = "MM/dd/yy"
                } else if elapsedTimeInSeconds > secondInDays {
                    dateFormatter.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
        }
    }
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        // print(imageView.hasAmbiguousLayout)
        return imageView
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    // create a gray sperators for the cells
    let dividerLineView: UIView = {
       let dividerView = UIView()
        dividerView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return dividerView
    }()
    
    // add label for profile name
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Mark Zuckerberg"
        return label
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "this is the message from your friend. its about to go down"
        label.textColor = .gray
        return label
    }()
    
    let timeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.text = "12:05 pm"
        return label
    }()
    
    
    
    override func setupViews() {
        //
        // backgroundColor = .white
        addSubview(profileImageView)
        addSubview(dividerLineView)
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "zuckprofile")
        hasReadImageView.image = UIImage(named: "zuckprofile")
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(68)]", options: NSLayoutFormatOptions(), metrics: nil,
                                                      views: ["v0": profileImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(68)]", options: NSLayoutFormatOptions(), metrics: nil,
        views: ["v0": profileImageView]))
        
        // add constraint to center the profile image view
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        // add constraints to the divider line view
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-82-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dividerLineView]))
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dividerLineView]))
        setupContainerView()
       
    }
    
    // create a function to set up the container view for the labels
    private func setupContainerView(){
        // add a view to contain the texts
        let containerView: UIView = UIView()
        // containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        hasReadImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        // add constraints for the container View
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-90-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": containerView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": containerView]))
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        // add constraints to the labels
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0][v1(80)]-12-|", options: NSLayoutFormatOptions(), metrics: nil,
                                                      views: ["v0":nameLabel, "v1":timeLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1(24)]|", options: NSLayoutFormatOptions(), metrics: nil,
                                                      views: ["v0":nameLabel, "v1":messageLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]-8-[v1(20)]-12-|", options: NSLayoutFormatOptions(), metrics: nil,
                                                      views: ["v0":messageLabel, "v1":hasReadImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(24)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : timeLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(20)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : hasReadImageView]))

    }
}



class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        // set up views layout
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
