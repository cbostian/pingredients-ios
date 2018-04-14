//
//  ViewController.swift
//  pingredients
//
//  Created by Catherine Bostian on 1/18/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import UIKit
import PinterestSDK
import SwiftyJSON

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_: Bool) {
        PDKClient.sharedInstance().authenticate(
            withPermissions: [PDKClientReadPublicPermissions], from: self,
            withSuccess: {(PDKResponseObject) in
                print(PDKClient.sharedInstance().oauthToken)
                self.performSegue(withIdentifier: "loginSegue", sender: self)
        },
            andFailure: {(PDKResponseObject) in
                print(PDKResponseObject!)
        }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

