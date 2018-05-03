//
//  PingredientsTabController.swift
//  pingredients
//
//  Created by Jimmy Burgess on 5/2/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation
import UIKit

class PingredientsTabController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        print("CATTTT!")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("HEY!!!")
    }
}
