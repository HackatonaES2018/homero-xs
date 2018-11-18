//
//  RGInputViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import YPImagePicker
import UIKit

class RGInputViewController: UIViewController {
    let showValidation = "showValidation"
    
    @IBAction func cameraAction(_ sender: UIButton) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = false
        config.targetImageSize = .cappedTo(size: 1280)
        config.usesFrontCamera = true
        config.showsFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.screens = [.photo, .library]
        config.startOnScreen = .library
        config.showsCrop = .rectangle(ratio: (1280/720))
        config.wordings.libraryTitle = "Galeria"
        config.wordings.albumsTitle = "Álbuns"
        config.wordings.cameraTitle = "Câmera"
        config.wordings.cancel = "Cancelar"
        config.wordings.crop = "Cortar"
        config.wordings.done = "OK"
        config.wordings.next = "Próximo"
        config.wordings.processing = "Processando..."
        config.wordings.save = "Salvar"
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = false
        
        let picker = YPImagePicker(configuration: config)
        present(picker, animated: true)
        picker.didFinishPicking { medias, status in
            guard case .photo(p: let photo) = medias.first! else {
                return
            }
            
            picker.dismiss(animated: true)
            self.lock()
            let ppp = photo.image.scale(to: CGSize(width: 1280, height: 720))
            Biometrics.shared.uploadDocPhoto(ppp) { (successed, error) in
                self.unlock()
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
    }
    
}
