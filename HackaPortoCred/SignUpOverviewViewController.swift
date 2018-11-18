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

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let person = person {
            name.text = person.name
            birthDate.text = dateFormatter.string(from: person.birthDate)
            mail.text = person.email
            phone.text = person.phoneNumber
            cpf.text = person.cpf
        }
    }

    @IBAction func validateInfo(_ sender: UIBarButtonItem) {
        guard let person = person else { return }
        Biometrics.shared.createUser(person) { (success, error) in
            
        }
    }
}
