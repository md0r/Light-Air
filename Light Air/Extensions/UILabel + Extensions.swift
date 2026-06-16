//
//  UILabel + Extensions.swift
//  Light Air
//
//  Created by Mihai on 09/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    static func getHeaderLabelForTableView(parentView: UIView) -> UILabel {
       let label = UILabel()
       label.frame = CGRect.init(x: 20, y: 6, width: parentView.frame.width-40, height: parentView.frame.height-11)
       label.font = UIFont.boldSystemFont(ofSize: 14)
       label.textColor = UIColor.white
       return label
    }
    
}
