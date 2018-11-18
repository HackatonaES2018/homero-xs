//
//  TermsViewController.swift
//  HackaPortoCred
//
//  Created by Rafael Victor Ruwer Araujo on 18/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    @IBOutlet weak var agreeSwitch: UISwitch!
    @IBOutlet weak var continueButton: GreenButton!
    @IBOutlet weak var termsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.alpha = 0.5
        agreeSwitch.tintColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        agreeSwitch.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        
        self.lock()
        termsTextView.text = ""
        PortoCredApi.shared.getConditions { condition, _ in
            guard let condition = condition else {
                return
            }
            
            DispatchQueue.main.async {
                self.unlock()
                self.termsTextView.text = condition.conditions
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        agreeSwitch.layer.cornerRadius = agreeSwitch.frame.height / 2
    }
    
    @IBAction func changeSwitch(_ sender: UISwitch) {
        continueButton.isEnabled = sender.isOn
        continueButton.alpha = sender.isOn ? 1 : 0.5
    }
}
