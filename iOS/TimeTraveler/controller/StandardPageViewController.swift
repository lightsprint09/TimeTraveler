//
//  StandardPageViewController.swift
//  TidyUp
//
//  Created by Lukas Schmidt on 16.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit

protocol StandardPageViewController: UIPageViewControllerDataSource {
    var controllers:Array<UIViewController> { get }
    var currentControllerIndex: Int { get set }
}

extension StandardPageViewController {
    func getNthNextController(currentCiewController: UIViewController, nthIndexInxex: Int) -> UIViewController? {
        guard let index = controllers.indexOf(currentCiewController) where index + nthIndexInxex >= 0 && index + nthIndexInxex < controllers.count else { return nil }
        currentControllerIndex = index + nthIndexInxex
        return controllers[currentControllerIndex]
    }
}