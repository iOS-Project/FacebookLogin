//
//  ViewController.swift
//  FacebookDemo
//
//  Created by Lun Sovathana on 11/21/16.
//  Copyright © 2016 Lun Sovathana. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FacebookShare

class ViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = ""
        
        // Add FacebookButton
        let loginButton = LoginButton(readPermissions: [.email, .publicProfile])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        if AccessToken.current != nil{
            fetchInfo()
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("Login")
        fetchInfo()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logout")
        
        usernameLabel.text = "Click Login Below"
    }
    
    
    func fetchInfo(){
        let connection = GraphRequestConnection()
        
        let request = GraphRequest(graphPath: "/me", parameters: ["fields":"id, name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        
        connection.add(request, batchEntryName: nil){
            httpResponse, result in
            switch result {
            case .success(let response):
                let resp = response.dictionaryValue
                self.usernameLabel.text = "Full Name: \(resp?["name"] as! String)"
                print("Graph Request Succeeded: \(response)")
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }

}

