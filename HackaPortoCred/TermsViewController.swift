//
//  TermsViewController.swift
//  HackaPortoCred
//
//  Created by Rafael Victor Ruwer Araujo on 18/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit
import CoreLocation

class TermsViewController: UIViewController {
    @IBOutlet weak var agreeSwitch: UISwitch!
    @IBOutlet weak var continueButton: GreenButton!
    @IBOutlet weak var termsTextView: UITextView!
    let showSuccess = "showSuccess"
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.alpha = 0.5
        agreeSwitch.tintColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        agreeSwitch.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        
        termsTextView.delegate = self
        
        self.lock()
        termsTextView.text = ""
        PortoCredApi.shared.getConditions { condition, _ in
            guard let condition = condition else {
                return
            }
            
            DispatchQueue.main.async {
                self.unlock()
                self.termsTextView.text = condition.conditions
                // Ask for Authorisation from the User.
                self.locationManager.requestAlwaysAuthorization()
                // For use in foreground
                self.locationManager.requestWhenInUseAuthorization()
                
                if CLLocationManager.locationServicesEnabled() {
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.locationManager.startUpdatingLocation()
                    
                }
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
    @IBAction func continueAction() {
        lock()
        PortoCredApi.shared.confirmProposal { (situation, _) in
            guard let situation = situation else { return }
            DispatchQueue.main.async {
                self.unlock()
                self.performSegue(withIdentifier: self.showSuccess, sender: nil)

            }
        }
    }
}

extension TermsViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            // reach bottom
            agreeSwitch.isOn = true
            continueButton.isEnabled = true
            continueButton.alpha = 1
        }
    }
}

extension TermsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
