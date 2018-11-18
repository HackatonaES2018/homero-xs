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
        if indexPath.row == 0 {
            cell.title = "Nome"
            cell.textField.placeholder = "John Doe"
            cell.textField.text = person.name
        } else if indexPath.row == 1 {
            cell.title = "Data de nascimento"
            cell.textField.placeholder = "XX/XX/XXXX"
            if let date = date {
                cell.textField.text = dateFormatter.string(from: date)
            }
        } else if indexPath.row == 2 {
            cell.title = "E-Mail"
            cell.textField.placeholder = "john.doe@mail.com"
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
