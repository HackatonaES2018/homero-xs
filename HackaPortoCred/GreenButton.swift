//
//  GreenButton.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class GreenButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.7725490196, blue: 0.1411764706, alpha: 1)
        layer.cornerRadius = frame.height * 0.5
    }
}

