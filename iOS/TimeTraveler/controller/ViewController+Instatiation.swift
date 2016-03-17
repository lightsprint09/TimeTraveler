//
//  ViewController+Instatiation.swift
//  CardScore
//
//  Created by Lukas Schmidt on 17.09.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit

extension UIViewController {
    func instantiateViewControllerWithIdentifier <T: UIViewController>(indentifier:String, storyBoardName:String = "Main") -> T {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        guard let viewController = storyboard.instantiateViewControllerWithIdentifier(indentifier) as? T else {
            fatalError("Wrong ViewController Type")
        }
        
        return viewController
    }
}