//
//  Biometrics.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

struct Person {
    var name: String
    var email: String
    var birthDate: Date
    var cpf: String
    var phoneNumber: String
}

class Biometrics {
    static let shared = Biometrics()
    
    private init() {}
    
    func createUser(_ user: Person, completion: @escaping (Bool?, Error?) -> Void) {
        
    }
    
    func uploadFacePhoto(_ image: UIImage, completion: @escaping (Bool?, Error?) -> Void) {
        
    }
    
    func uploadDocPhoto(_ image: UIImage, completion: @escaping (Bool?, Error?) -> Void) {
        
    }
    
    func validate(completion: @escaping (Bool?, Error?) -> Void) {
        
    }
}
