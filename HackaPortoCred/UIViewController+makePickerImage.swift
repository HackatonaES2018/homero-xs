//
//  UIViewController+makePickerImage.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    func showImagePickerOpitions(_ imagePicker: UIImagePickerController) {
        let alert = UIAlertController(title: "Selecione uma origem", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Câmera", style: .default, handler: { _ in
            self.openCamera(imagePicker)
        }))
        
        alert.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { _ in
            self.openGallary(imagePicker)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera(_ imagePicker: UIImagePickerController) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Atenção!", message: "Você não tem uma câmera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(_ imagePicker: UIImagePickerController) {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension UIViewController {
    func lock() {
        let view: UIView = self.tabBarController?.view ?? self.navigationController?.view ?? self.view
        
        let blurView = UIView()
        blurView.tag = 9999
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        blurView.addSubview(activityIndicatorView)
        view.addSubview(blurView)
        view.bringSubviewToFront(blurView)
        blurView.isUserInteractionEnabled = false
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurView.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
            view.topAnchor.constraint(equalTo: blurView.topAnchor),
            view.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
            ])
    }
    
    func unlock() {
        let view: UIView = self.tabBarController?.view ?? self.navigationController?.view ?? self.view
        view.subviews.first(where: { $0.tag == 9999 })?.removeFromSuperview()
    }
}
