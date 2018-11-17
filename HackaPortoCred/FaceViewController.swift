//
//  FaceViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    let showRG = "showRG"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    
    @IBAction func cameraAction(_ sender: UIButton) {
        showImagePickerOpitions(imagePicker)
    }
    
}

extension FaceViewController: UINavigationControllerDelegate {}
extension FaceViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        Biometrics.shared.uploadFacePhoto(editedImage) { (successed, error) in
            if let error = error {
                self.showAlert(title: "Erro", message: error.localizedDescription)
            } else if let successed = successed {
                if successed {
                    self.performSegue(withIdentifier: self.showRG, sender: nil)
                } else {
                    self.showAlert(title: "Erro", message: "Não possivel reconhecer o rosto.")
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}


