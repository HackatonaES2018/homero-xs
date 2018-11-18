//
//  OfferViewController.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 18/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import YPImagePicker
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
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 10
        
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
    
    private var cpf: String = ""
    private var birthDate: String = ""
    private var name = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSignUp" {
            let vc = segue.destination as? SignUpViewController
            vc?.person.name = name
            vc?.person.cpf = cpf
            
            if !self.birthDate.isEmpty {
                let df = DateFormatter()
                df.dateFormat = "dd/MM/yyyy"
                if let date = df.date(from: birthDate) {
                    vc?.date = date
                    vc?.person.birthDate = date
                }
            }
        }
    }
    
    @IBAction func acceptOffer(_ sender: GreenButton, forEvent event: UIEvent) {
        showImageSelection() { image in
            guard let image = image else {
                return
            }
            
            self.lock()
            VisionApi.shared.parse(image) { cpf, birthDate, name in
                self.unlock()
                print(cpf, birthDate)
                self.cpf = cpf
                self.birthDate = birthDate
                self.name = name
                self.performSegue(withIdentifier: "showSignUp", sender: self)
            }
        }
    }
    
    private func showImageSelection(completion: @escaping (UIImage?) -> Void) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = false
        config.targetImageSize = .cappedTo(size: 1280)
        config.usesFrontCamera = false
        config.showsFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.screens = [.photo, .library]
        config.startOnScreen = .photo
        config.showsCrop = .rectangle(ratio: (4/3))
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
            picker.dismiss(animated: true)
            completion(medias.singlePhoto?.image)
        }
    }
}
