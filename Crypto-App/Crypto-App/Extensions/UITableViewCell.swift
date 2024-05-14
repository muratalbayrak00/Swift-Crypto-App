//
//  UITableViewCell.swift
//  Crypto-App
//
//  Created by murat albayrak on 14.05.2024.
//

import UIKit


extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
