//
//  Settings.swift
//  Light Air
//
//  Created by Mihai on 02/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import UIKit

struct ThemeManager {
    
    static func setup() {
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor(displayP3Red: 30/255, green: 121/255, blue: 40/255, alpha: 1.0)
        
        if #available(iOS 13.0, *) {
             let appearance = UINavigationBarAppearance()
             appearance.backgroundColor = UIColor(displayP3Red: 79/255, green: 206/255, blue: 93/255, alpha: 1.0)
             appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
             appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

             UINavigationBar.appearance().tintColor = .white
             UINavigationBar.appearance().standardAppearance = appearance
             UINavigationBar.appearance().compactAppearance = appearance
             UINavigationBar.appearance().scrollEdgeAppearance = appearance
           
        } else {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 79/255, green: 206/255, blue: 93/255, alpha: 1.0)
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBarAppearance().titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBarAppearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
    
    static func addHeaderImageToNavigationController(sender: UIViewController, width: Int, height: Int) {
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "titlebar")
        imageView.image = image
        logoContainer.addSubview(imageView)
        sender.navigationItem.titleView = logoContainer
    }
    
}
