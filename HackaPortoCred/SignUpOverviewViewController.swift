//
//  SingupOverviewViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class SignUpOverviewViewController: UIViewController {

    static let identifier = "SingupOverviewViewController"

    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func validateInfo(_ sender: UIBarButtonItem) {
        guard let person = person else { return }
        Biometrics.shared.createUser(person) { (success, error) in
            
        }
    }
}
