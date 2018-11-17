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
    let datePicker = UIDatePicker()
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setupDatePicker()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showInfo", let destination = segue.destination as? SingupOverviewViewController else {
            return
        }
        destination.person = person
    }

    func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(getDate), for: .valueChanged)
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
    }
    
    @objc func getDate(sender: UIDatePicker) {
        date = sender.date
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? UISignUpTableViewCell else {
            return
        }
        cell.textField.text = date?.description
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
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        if indexPath.row == 0 {
            cell.title = "Nome"
            cell.textField.placeholder = "John Doe"
            cell.textField.text = person.name
        } else if indexPath.row == 1 {
            cell.title = "Data de nacimento"
            cell.textField.placeholder = "XX/XX/XXXX"
            cell.textField.text = date?.description
        } else if indexPath.row == 2 {
            cell.title = "E-Mail"
            cell.textField.placeholder = "john.doe@test.com"
            cell.textField.text = person.email
        } else if indexPath.row == 3 {
            cell.title = "Celular"
            cell.textField.placeholder = "(00)00000-0000"
            cell.textField.text = person.phoneNumber
        } else if indexPath.row == 4 {
            cell.title = "CPF"
            cell.textField.placeholder = "000.000.000-00"
            cell.textField.text = person.cpf
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            textField.keyboardType = .namePhonePad
            textField.textContentType = .name
        case 1:
            textField.inputView = datePicker
        case 2:
            textField.keyboardType = .emailAddress
            textField.textContentType = .emailAddress
        case 3:
            textField.keyboardType = .numberPad
            textField.textContentType = .telephoneNumber
        case 4:
            textField.keyboardType = .numberPad
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        switch textField.tag {
        case 0:
            person.name = text
        case 1:
            break
        case 2:
            person.email = text
        case 3:
            person.phoneNumber = text
        case 4:
            person.cpf = text
        default:
            break
        }
    }
}
