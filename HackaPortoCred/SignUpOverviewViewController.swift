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

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var cpf: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = person?.name
        birthDate.text = person?.birthDate.description
        mail.text = person?.email
        phone.text = person?.phoneNumber
        cpf.text = person?.cpf
    }

    @IBAction func validateInfo(_ sender: UIBarButtonItem) {
        guard let person = person else { return }
        Biometrics.shared.createUser(person) { (success, error) in
            
        }
    }
}
