//
//  OfferViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 18/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class OfferViewController: UIViewController {

    let numberFormatter: NumberFormatter = {
       let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }()
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var offerValue: UILabel!
    
    @IBOutlet weak var numberOfParcels: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 6
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lock()
        PortoCredApi.shared.getOffer { (cet, error) in
            DispatchQueue.main.async {
                guard let cet = cet else { return }
                self.unlock()
                let number = NSNumber(value: cet.totalValue)
                self.offerValue.text = self.numberFormatter.string(from: number)
                self.numberOfParcels.text = "\(cet.term) Parcelas"
            }
        }
    }

    @IBAction func newOffer() {
        lock()
        PortoCredApi.shared.getOffer { (cet, error) in
            DispatchQueue.main.async {
                guard let cet = cet else { return }
                self.unlock()
                let totalValue = cet.totalValue + Double.random(in: 0...1000)
                let number = NSNumber(value: totalValue)
                self.offerValue.text = self.numberFormatter.string(from: number)
                self.numberOfParcels.text = "\(cet.term - Int.random(in: 1...3)) Parcelas"
            }
        }
    }
}
