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
        
        if view.viewWithTag(9999) != nil {
            return
        }
        
        let blurView = UIView()
        blurView.tag = 9999
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        blurView.alpha = 0
        
        let greenView = UIView()
        greenView.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.7725490196, blue: 0.1411764706, alpha: 1)
        greenView.layer.cornerRadius = 5
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        
        greenView.addSubview(activityIndicatorView)
        blurView.addSubview(greenView)
        view.addSubview(blurView)
        view.bringSubviewToFront(blurView)
        blurView.isUserInteractionEnabled = false
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: greenView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: greenView.centerYAnchor),
            greenView.widthAnchor.constraint(equalToConstant: 100),
            greenView.heightAnchor.constraint(equalToConstant: 100),
            greenView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            greenView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
            view.topAnchor.constraint(equalTo: blurView.topAnchor),
            view.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
            ])
        
        UIView.animate(withDuration: 0.25) {
            blurView.alpha = 1
        }
    }
    
    func unlock() {
        let view: UIView = self.tabBarController?.view ?? self.navigationController?.view ?? self.view
        let blurView = view.viewWithTag(9999)
        
        UIView.animate(withDuration: 0.25, animations: {
            blurView?.alpha = 0
        }) { _ in
            blurView?.removeFromSuperview()
        }
    }
}
