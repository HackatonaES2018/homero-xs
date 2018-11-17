//
//  SinupViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class SigupViewController: UIViewController {

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SigupViewController: UITableViewDelegate, UITableViewDataSource {

    func setTableView() {
        tableView.register(UISignUpTableViewCell.self, forCellReuseIdentifier: UISignUpTableViewCell.identifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UISignUpTableViewCell(frame: .zero)
        if indexPath.row == 0 {
            cell.textField.placeholder = "Nome"
        } else if indexPath.row == 2 {
            cell.textField.placeholder = "Data de nscimento"
        } else if indexPath.row == 2 {
            cell.textField.placeholder = "E-Mail"
        } else if indexPath.row == 3 {
            cell.textField.placeholder = "Celular"
        } else if indexPath.row == 4 {
            cell.textField.placeholder = "CPF"
        }
        return cell;
    }
    
    
}
