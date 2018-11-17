//
//  Biometrics.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import Foundation
import UIKit

struct Person {
    let name: String
    let email: String
    let birthDate: Date
    let cpf: String
    let phoneNumber: String
    
    func makePayload() -> [String: String] {
        let cleanCPF = cpf.split(whereSeparator: { $0 == "." || $0 == "-" }).joined(separator: "")
        let cleanPhoneNumber = phoneNumber.split(whereSeparator: { ["(", ")", " ", "-"].contains(String($0)) }).joined(separator: "")
        
        let json = [
            "Code": cleanCPF,
            "Name": name,
            "Phone": cleanPhoneNumber,
            "Email": email,
        ]
        
        return json
    }
}

class Biometrics {
    static let shared = Biometrics()
    
    private var authURL = URL(string: "https://crediariohomolog.acesso.io/portocred/services/v2/CredService.svc/user/authToken")!
    private var processCreateURL = URL(string: "https://crediariohomolog.acesso.io/portocred/services/v2/CredService.svc/process/create/1")!
    
    private var authToken: String?
    
    private init() {}
    
    private func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: authURL)
        request.httpMethod = "GET"
        request.setValue("53C8D9A5-0C9C-494B-A4E2-DB089E73CC3B", forHTTPHeaderField: "X-AcessoBio-APIKEY")
        request.setValue("INTEGRACAO.PORTOCRED", forHTTPHeaderField: "X-Login")
        request.setValue("Integracao!2018", forHTTPHeaderField: "X-Password")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            let resp = response as! HTTPURLResponse
            if error != nil || resp.statusCode >= 300 {
                completion(false, error)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data!) as! [String: Any]
            if let result = json["GetAuthTokenResult"] as? [String: Any], let authToken = result["AuthToken"] as? String {
                self.authToken = authToken
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
        
        dataTask.resume()
    }
    
    func createUser(_ user: Person, completion: @escaping (Bool?, Error?) -> Void) {
        authenticate { status, error in
            guard error == nil, status else {
                completion(false, error)
                return
            }
            
            var request = URLRequest(url: self.processCreateURL)
            request.httpMethod = "POST"
            request.setValue("53C8D9A5-0C9C-494B-A4E2-DB089E73CC3B", forHTTPHeaderField: "X-AcessoBio-APIKEY")
            request.setValue("INTEGRACAO.PORTOCRED", forHTTPHeaderField: "X-Login")
            request.setValue("Integracao!2018", forHTTPHeaderField: "X-Password")
            guard let authToken = self.authToken else { fatalError("call authenticate first!") }
            request.setValue(authToken, forHTTPHeaderField: "Authentication")
            
            let payload = [ "subject": user.makePayload() ]
            request.httpBody = try! JSONSerialization.data(withJSONObject: payload)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    completion(false, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(false, nil)
                    return
                }
                
                completion(response.statusCode == 200, nil)
            }
            
            dataTask.resume()
        }
    }
    
    func uploadFacePhoto(_ image: UIImage, completion: @escaping (Bool?, Error?) -> Void) {
//        guard let authToken = self.authToken else {
//            fatalError("call createUser first!")
//        }
//
//        let imageData = image.pngData()!
//        let base64 = imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    func uploadDocPhoto(_ image: UIImage, completion: @escaping (Bool?, Error?) -> Void) {
        
    }
    
    func validate(completion: @escaping (Bool?, Error?) -> Void) {
        
    }
}
