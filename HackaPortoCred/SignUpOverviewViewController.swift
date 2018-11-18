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
        self.lock()
        Biometrics.shared.createUser(person) { (success, error) in
            self.unlock()
            if success ?? false, error == nil {
                self.performSegue(withIdentifier: "showFacePhoto", sender: self)
            } else {
                self.showAlert(title: "Oops!", message: "Algo errado aconteceu. Tente novamente mais tarde.")
            }
        }
    }
}
