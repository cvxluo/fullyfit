//
//  ViewController.swift
//  fullyfit
//
//  Created by Charlie Luo on 9/8/18.
//

import UIKit
import FacebookCore
import FacebookLogin

class FBSignInViewController: UIViewController {
    
    var accessToken:AccessToken?
    
    @IBAction func signInPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .userEvents ], viewController: self) { LoginResult in
            switch LoginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                self.checkIfLogged()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.checkIfLogged()
        
        
    }
    
    func checkIfLogged() {
        if let accessToken = AccessToken.current {
            self.accessToken = accessToken
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var vc = storyboard.instantiateViewController(withIdentifier: "Events")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is FBEventsViewController
        {
            let vc = segue.destination as? FBEventsViewController
            vc?.accessToken = self.accessToken
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



