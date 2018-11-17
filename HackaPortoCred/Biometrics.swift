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
    private var faceInsert: URL {
        return URL(string: "https://crediariohomolog.acesso.io/portocred/services/v2/CredService.svc/process/\(self.processId!)/faceInsert")!
    }
    
    private var authToken: String?
    private var processId: String?
    
    private init() {}
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    private func makeRequest(url: URL, method: HTTPMethod, auth: Bool = false, payload: Any? = nil) -> URLRequest {
        var headers = [
            "Content-Type": "application/json",
            "X-AcessoBio-APIKEY": "53C8D9A5-0C9C-494B-A4E2-DB089E73CC3B",
            "X-Login": "INTEGRACAO.PORTOCRED",
            "X-Password": "Integracao!2018",
            ]
        
        if auth {
            headers["Authentication"] = self.authToken!
        }
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let payload = payload {
            let postData = try! JSONSerialization.data(withJSONObject: payload)
            request.httpBody = postData
        }
        
        return request as URLRequest
    }
    
    private func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        let request = self.makeRequest(url: authURL, method: .get)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async { completion(false, error) }
                return
            }
            
            if let authToken = JSON(data!)["GetAuthTokenResult"]["AuthToken"].string {
                self.authToken = authToken
                DispatchQueue.main.async { completion(true, nil) }
            } else {
                DispatchQueue.main.async { completion(false, nil) }
            }
        }

        dataTask.resume()
    }
    
    func createUser(_ user: Person, completion: @escaping (Bool?, Error?) -> Void) {
        authenticate { status, error in
            guard error == nil, status else {
                DispatchQueue.main.async { completion(false, error) }
                return
            }
            
            let payload = ["subject": user.makePayload()] as [String: Any]
            let request = self.makeRequest(url: self.processCreateURL, method: .post, auth: true, payload: payload)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    DispatchQueue.main.async { completion(false, error) }
                    return
                }
                
                if let processId = JSON(data!)["CreateProcessResult"]["Process"]["Id"].string {
                    self.processId = processId
                    DispatchQueue.main.async { completion(true, nil) }
                } else {
                    DispatchQueue.main.async { completion(false, nil) }
                }
            }
            
            dataTask.resume()
        }
    }
    
    func uploadFacePhoto(_ image: UIImage, completion: @escaping (Bool?, Error?) -> Void) {
        let base64 = image.jpegData(compressionQuality: 1)!.base64EncodedString()
        let payload = ["imagebase64": base64]
        let request = self.makeRequest(url: faceInsert, method: .post, auth: true, payload: payload)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async { completion(false, error) }
                return
            }
            
            if let errorCode = JSON(data!)["FaceInsertResult"]["Error"]["Code"].int, errorCode == 0 {
                DispatchQueue.main.async { completion(true, nil) }
            } else {
                DispatchQueue.main.async { completion(false, nil) }
            }
        }
        
        dataTask.resume()
    }
    
    func uploadDocPhoto(_ image: UIImage, completion: @escaping (Bool?, Error?) -> Void) {
        
    }
    
    func validate(completion: @escaping (Bool?, Error?) -> Void) {
        
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
