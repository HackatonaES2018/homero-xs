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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    
    @IBAction func cameraAction(_ sender: UIButton) {
        let alert = makeImagePickerOpitions(imagePicker)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension FaceViewController: UINavigationControllerDelegate {}
extension FaceViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}


