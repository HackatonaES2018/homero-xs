//
//  ValidationViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class ValidationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Biometrics.shared.validate { (successed, error) in
            if let error = error {
                self.showAlert(title: "Erro", message: error.localizedDescription)
            } else if let successed = successed {
                if successed {
                    self.showAlert(title: "Erro", message: "Foi possivel validar")
                } else {
                    self.showAlert(title: "Erro", message: "Não possivel validar")
                }
            }
        }
    }

}
