//
//  Biometrics.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import Alamofire
import Foundation
import UIKit

struct Person {
    let name: String
    let email: String
    let birthDate: Date
    let cpf: String
    let phoneNumber: String
    
    func makePayload() -> [String: String] {
        return [
            "Code": cpf,
            "Name": name,
            "Phone": phoneNumber,
            "Email": email,
        ]
    }
}

class Biometrics {
    static let shared = Biometrics()
    
    private var authURL =
        URL(string: "https://crediariohomolog.acesso.io/portocred/services/v2/CredService.svc/user/authToken")!
    private var processCreateURL =
        URL(string: "https://crediariohomolog.acesso.io/portocred/services/v2/CredService.svc/process/create/1")!
    
    private var authToken: String?
    private var processId: String?
    
    private init() {}
    
    private func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: authURL)
        request.httpMethod = "GET"
        request.setValue("53C8D9A5-0C9C-494B-A4E2-DB089E73CC3B", forHTTPHeaderField: "X-AcessoBio-APIKEY")
        request.setValue("INTEGRACAO.PORTOCRED", forHTTPHeaderField: "X-Login")
        request.setValue("Integracao!2018", forHTTPHeaderField: "X-Password")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
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
            let headers = [
                "Content-Type": "application/json",
                "X-AcessoBio-APIKEY": "53C8D9A5-0C9C-494B-A4E2-DB089E73CC3B",
                "X-Login": "INTEGRACAO.PORTOCRED",
                "X-Password": "Integracao!2018",
                "Authentication": self.authToken!,
            ]
            
            let parameters = ["subject": user.makePayload()] as [String : Any]
            let postData = try! JSONSerialization.data(withJSONObject: parameters)
            
            let request = NSMutableURLRequest(url: self.processCreateURL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData
            
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil {
                    completion(false, error)
                } else {
                    let result = try! JSONSerialization.jsonObject(with: data!) as! [String: Any]
                    print(result)
                    let createProcessResult = result["CreateProcessResult"] as! [String: Any]
                    let process = createProcessResult["Process"] as! [String: Any]
                    let id = process["Id"] as! String
                    self.processId = id
                    completion(true, nil)
                }
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
