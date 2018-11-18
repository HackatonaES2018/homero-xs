//
//  ViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var simulateButton: GreenButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        simulateButton.isEnabled = false
        simulateButton.alpha = 0.6
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
        var text = textField.text!.replacingOccurrences(of: "R$", with: "")
        text = text.replacingOccurrences(of: ",00", with: "")
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: ".", with: "")
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let number = Int(text) {
            if number == 0 {
                simulateButton.isEnabled = false
                simulateButton.alpha = 0.6
            }
        } else {
            simulateButton.isEnabled = false
            simulateButton.alpha = 0.6
        }
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        var text = textField.text!.replacingOccurrences(of: "R$", with: "")
        text = text.replacingOccurrences(of: ",00", with: "")
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: ".", with: "")
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let number = Int(text) {
            if number == 0 {
                simulateButton.isEnabled = false
                simulateButton.alpha = 0.6
                textField.text = ""
            } else if let formattedTipAmount = formatter.string(from: number as NSNumber) {
                textField.text = "\(formattedTipAmount)"
                simulateButton.isEnabled = true
                simulateButton.alpha = 1
            }
        } else {
            simulateButton.isEnabled = false
            simulateButton.alpha = 0.6
        }
    }

}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            textField.text = ""
        }
        return true
    }
}
