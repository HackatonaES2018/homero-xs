//
//  UISignUpTableViewCell.swift
//  HackaPortoCred
//
//  Created by Eduardo Fornari on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class UISignUpTableViewCell: UITableViewCell {

    static let identifier = String(describing: self)

    public let textField = UITextField()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - TextField
    
    private func setTextField() {
        textField.placeholder = "Placeholder"
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
            ])
    }
}
