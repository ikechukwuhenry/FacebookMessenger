//
//  CustomTabBarController.swift
//  Facebook_Messenger
//
//  Created by Ikechukwu Michael on 26/01/2018.
//  Copyright © 2018 Ikechukwu Michael. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let friendsViewController = FriendsViewController(collectionViewLayout: layout)
        let recentMessageNavController = UINavigationController(rootViewController: friendsViewController)
        recentMessageNavController.tabBarItem.title = "Recent"
        recentMessageNavController.tabBarItem.image = UIImage(named: "recent")
        
        let callsController = createNavController(title: "Calls", imageName: "calls")
        let peopleController = createNavController(title: "People", imageName: "people")
        let groupsController = createNavController(title: "Groups", imageName: "groups")
        let settingsController = createNavController(title: "Settings", imageName: "settings")
        viewControllers = [recentMessageNavController, callsController, groupsController, peopleController, settingsController]
        
        
    }
    
    private func createNavController(title: String, imageName: String)-> UINavigationController{
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
