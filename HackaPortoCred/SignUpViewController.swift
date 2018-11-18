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

    var person: Person = Person(name: "",
                                email: "",
                                birthDate: Date(),
                                cpf: "",
                                phoneNumber: "")

    private let pageControll = UIPageControl()

    let datePicker = UIDatePicker()
    var date: Date? {
        didSet {
            if let date = date {
                person.birthDate = date
            }
        }
    }
    let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setPageControl()
        setupDatePicker()
        previousButton.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SignUpOverviewViewController.identifier, let destination = segue.destination as? SignUpOverviewViewController else {
            return
        }
        destination.person = person
    }

    func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(getDate), for: .valueChanged)
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
    }

    private func setPageControl() {
        pageControll.numberOfPages = 5
        pageControll.currentPageIndicatorTintColor = #colorLiteral(red: 0.5921568627, green: 0.7725490196, blue: 0.1411764706, alpha: 1)
        pageControll.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.addSubview(pageControll)
        pageControll.translatesAutoresizingMaskIntoConstraints = false
        let marginTop: CGFloat = 20
        NSLayoutConstraint.activate([
            pageControll.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: marginTop),
            pageControll.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageControll.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    @objc func getDate(sender: UIDatePicker) {
        date = sender.date
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? UISignUpTableViewCell else {
            return
        }
        if let date = date {
            cell.textField.text = dateFormatter.string(from: date)
            cell.button.isEnabled = true
            cell.button.alpha = 1
        }
    }
    @IBAction func previousAction(_ sender: UIButton) {
        guard let indexPath = tableView.indexPathsForVisibleRows?.first else { return }
        view.endEditing(true)
        if indexPath.row != 0 {
            pageControll.currentPage = indexPath.row - 1
        }
        if 1...4 ~= indexPath.row {
            if indexPath.row == 1 {
                previousButton.isHidden = true
            }
            tableView.scrollToRow(at: IndexPath(row: indexPath.row - 1, section: 0), at: .top, animated: true)
        }
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
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(nextAction(sender:)), for: .touchUpInside)
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if indexPath.row == 0 {
            cell.title = "Nome"
            cell.textField.placeholder = "John Doe"
            cell.textField.text = person.name
            if person.name.isEmpty {
                cell.button.isEnabled = false
                cell.button.alpha = 0.6
            } else {
                cell.button.isEnabled = true
                cell.button.alpha = 1
            }
            
        } else if indexPath.row == 1 {
            cell.title = "Data de nascimento"
            cell.textField.placeholder = "XX/XX/XXXX"
            if let date = date {
                cell.textField.text = dateFormatter.string(from: date)
                cell.button.isEnabled = true
                cell.button.alpha = 1
            } else {
                cell.button.isEnabled = false
                cell.button.alpha = 0.6
            }
        } else if indexPath.row == 2 {
            cell.title = "E-Mail"
            cell.textField.placeholder = "john.doe@mail.com"
            cell.textField.text = person.email
            if person.email.isEmpty {
                cell.button.isEnabled = false
                cell.button.alpha = 0.6
            } else {
                cell.button.isEnabled = true
                cell.button.alpha = 1
            }
        } else if indexPath.row == 3 {
            cell.title = "Celular"
            cell.textField.placeholder = "(00)00000-0000"
            cell.textField.text = person.phoneNumber
            if person.phoneNumber.isEmpty {
                cell.button.isEnabled = false
                cell.button.alpha = 0.6
            } else {
                cell.button.isEnabled = true
                cell.button.alpha = 1
            }
        } else if indexPath.row == 4 {
            cell.title = "CPF"
            cell.textField.placeholder = "000.000.000-00"
            cell.textField.text = person.cpf
            if person.cpf.isEmpty {
                cell.button.isEnabled = false
                cell.button.alpha = 0.6
            } else {
                cell.button.isEnabled = true
                cell.button.alpha = 1
            }
            var cpfAUX = person.cpf.replacingOccurrences(of: ".", with: "")
            cpfAUX = person.cpf.replacingOccurrences(of: "-", with: "")
            if !cpfAUX.isValidCPF {
                cell.button.isEnabled = false
                cell.button.alpha = 0.6
            } else {
                cell.button.isEnabled = true
                cell.button.alpha = 1
            }
        }
        return cell;
    }
    
    @objc func nextAction(sender: UIButton) {
        previousButton.isHidden = false
        if sender.tag != 4 {
            pageControll.currentPage = sender.tag + 1
        }
        view.endEditing(true)
        if 0..<4 ~= sender.tag {
            tableView.scrollToRow(at: IndexPath(row: sender.tag + 1, section: 0), at: .bottom, animated: true)
        }
        
        if sender.tag == 4 {
            performSegue(withIdentifier: SignUpOverviewViewController.identifier, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputView = nil
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
            textField.textContentType = nil
            textField.keyboardType = .numberPad
        default:
            break
        }
        
        return true
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? UISignUpTableViewCell else { return }
        if textField.text?.isEmpty ?? true {
            cell.button.isEnabled = false
            cell.button.alpha = 0.6
        } else {
            cell.button.isEnabled = true
            cell.button.alpha = 1
        }

        if textField.tag == 4 {
            textField.text = textField.text?.replacingOccurrences(of: ".", with: "")
            textField.text = textField.text?.replacingOccurrences(of: "-", with: "")
            if textField.text!.count > 11 {
                textField.text = String(textField.text!.dropLast())
            }
            if !textField.text!.isValidCPF {
                cell.button.isEnabled = false
                cell.button.alpha = 0.6
            } else {
                cell.button.isEnabled = true
                cell.button.alpha = 1
            }
            if textField.text?.count ?? 0 > 9 {
                let index1 = textField.text!.index(textField.text!.startIndex, offsetBy: 3)
                textField.text?.insert(".", at: index1)
                let index2 = textField.text!.index(textField.text!.startIndex, offsetBy: 7)
                textField.text?.insert(".", at: index2)
                let index3 = textField.text!.index(textField.text!.startIndex, offsetBy: 11)
                textField.text?.insert("-", at: index3)
            } else if textField.text?.count ?? 0 > 6 {
                let index1 = textField.text!.index(textField.text!.startIndex, offsetBy: 3)
                textField.text?.insert(".", at: index1)
                let index2 = textField.text!.index(textField.text!.startIndex, offsetBy: 7)
                textField.text?.insert(".", at: index2)
            } else if textField.text?.count ?? 0 > 3 {
                let index = textField.text!.index(textField.text!.startIndex, offsetBy: 3)
                textField.text?.insert(".", at: index)
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        switch textField.tag {
        case 0:
            person.name = text
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

extension String {
    var isValidCPF: Bool {
        let numbers = characters.compactMap({Int(String($0))})
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
}
