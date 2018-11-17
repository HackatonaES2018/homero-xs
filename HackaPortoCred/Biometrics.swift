//
//  Biometrics.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

struct Person {
    let name: String
    let email: String
    let birthDate: Date
    let cpf: String
    let phoneNumber: String
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
