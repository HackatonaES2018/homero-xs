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

    private let label = UILabel()
    public var title: String! {
        didSet {
            label.text = title
        }
    }

    private let line = UIView(frame: .zero)

    public let textField = UITextField()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLabel()
        setTextField()
        setLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK - Label

    private func setLabel() {
        label.textColor = #colorLiteral(red: 0.09803921569, green: 0.168627451, blue: 0.3647058824, alpha: 1)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let marginTop: CGFloat = 20
        let marginRightLeft: CGFloat = 20
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: marginTop),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -marginRightLeft),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: marginRightLeft)
            ])
    }

    // MARK: - TextField
    
    private func setTextField() {
        textField.placeholder = "Placeholder"
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        let marginTop: CGFloat = 5
        let marginRightLeft: CGFloat = 20
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: marginTop),
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -marginRightLeft),
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: marginRightLeft)
            ])
    }

    // MARK - Line

    private func setLine() {
        line.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.7725490196, blue: 0.1411764706, alpha: 1)
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        let marginTop: CGFloat = 5
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: marginTop),
            line.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            line.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
}
