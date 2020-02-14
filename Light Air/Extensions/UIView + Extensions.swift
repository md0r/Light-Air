//
//  UIView + Extensions.swift
//  Light Air
//
//  Created by Mihai on 09/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static func getHeaderForTableView(tableView: UITableView) -> UIView {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor(displayP3Red: 30/255, green: 121/255, blue: 40/255, alpha: 0.9)
        
        return headerView
        
    }
    
}



