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
        if Bundle.main.devEnvironment {
            self.login()
        }
        else {
            PDKClient.sharedInstance().authenticate(
                withPermissions: [PDKClientReadPublicPermissions], from: self,
                withSuccess: {(PDKResponseObject) in
                    userID = PDKResponseObject?.user().identifier ?? ""
                    oauthToken = PDKClient.sharedInstance().oauthToken
                    self.login()
                },
                andFailure: {(PDKResponseObject) in
                    print(PDKResponseObject!)
                }
            )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login() {
        createUser(callback: {
            if Constants.columns < 3 {
                orientationUtility.lockOrientation(.portrait, andRotateTo: .portrait)
            }
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        })
    }
    
}
