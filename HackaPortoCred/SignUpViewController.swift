//
//  SinupViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    var person: Person = Person(name: "",
                                email: "",
                                birthDate: Date(),
                                cpf: "",
                                phoneNumber: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showInfo", let destination = segue.destination as? SingupOverviewViewController else {
            return
        }
        destination.person = person
    }

}

extension SignUpViewController: UITableViewDelegate, UITableViewDataSource {

    func setTableView() {
        tableView.register(UISignUpTableViewCell.self, forCellReuseIdentifier: UISignUpTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UISignUpTableViewCell.identifier, for: indexPath) as? UISignUpTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.title = "Nome"
            cell.textField.placeholder = "John Doe"
        } else if indexPath.row == 2 {
            cell.title = "Data de nscimento"
            cell.textField.placeholder = "XX/XX/XXXX"
        } else if indexPath.row == 2 {
            cell.title = "E-Mail"
            cell.textField.placeholder = "E-Mail"
        } else if indexPath.row == 3 {
            cell.title = "Celular"
            cell.textField.placeholder = "john.doe@test.com"
        } else if indexPath.row == 4 {
            cell.title = "CPF"
            cell.textField.placeholder = "000.000.000-00"
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}
