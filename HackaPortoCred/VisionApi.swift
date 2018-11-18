//
//  VisionApi.swift
//  HackaPortoCred
//
//  Created by Rafael Victor Ruwer Araujo on 18/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

final class VisionApi {
    static let shared = VisionApi()
    
    private init() {}
    
    func parse(_ image: UIImage, completion: @escaping (String, String, String) -> Void) {
        let base64 = image.pngData()!.base64EncodedString()
        let payload = """
        {
          "requests":[
            {
              "image":{
                "content":"\(base64)"
              },
              "features":[
                {
                  "type":"TEXT_DETECTION"
                }
              ]
            }
          ]
        }
        """
        
        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyBDz-nJLEpixIeGbShs2L0bbZbPBXvqkrY")!
        let request = makeRequest(url: url, payload: payload)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil || (response as? HTTPURLResponse)?.statusCode != 200 {
                DispatchQueue.main.async { completion("", "", "") }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion("", "", "") }
                return
            }
            
            let json = JSON(data)
            let responses = json["responses"]
            
            var maxDescription = ""
            
            let ttt = responses[0]["textAnnotations"].arrayValue
            for elem in ttt {
                let desc = elem["description"].stringValue
                if desc.count > maxDescription.count {
                    maxDescription = desc
                }
            }
            
            let allText = maxDescription as NSString
            var cpf = ""
            var birthDate = ""
            var name = ""
            
            // cpf
            let cpfRegex = try! NSRegularExpression(pattern: "\\d{3}\\.\\d{3}\\.\\d{3}-\\d{2}")
            if let cpfMatch = cpfRegex.matches(in: allText as String,
                                               options: [],
                                               range: NSRange(location: 0, length: allText.length)).first {
                cpf = allText.substring(with: cpfMatch.range)
            }
            
            // birth date
            let dateRegex = try! NSRegularExpression(pattern: "\\d{2}/\\d{2}/\\d{4}")
            if let birthDateRegex = dateRegex.matches(in: allText as String,
                                                      options: [],
                                                      range: NSRange(location: 0, length: allText.length)).first {
                birthDate = allText.substring(with: birthDateRegex.range)
            }
            
            let nameRegex = try! NSRegularExpression(pattern: "NOME\\n.*\\nDOC\\.")
            if let fromNameRegex = nameRegex.matches(in: allText as String,
                                                      options: [],
                                                      range: NSRange(location: 0, length: allText.length)).first {
                name = allText.substring(with: fromNameRegex.range)
                name = name.replacingOccurrences(of: "NOME\n", with: "")
                    .replacingOccurrences(of: "\nDOC.", with: "")
                    .capitalized
            }
            DispatchQueue.main.async { completion(cpf, birthDate, name) }
        }
        
        dataTask.resume()
    }
    
    private func makeRequest(url: URL, payload: String) -> URLRequest {
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "POST"
        request.httpBody = payload.data(using: .utf8)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        
        return request as URLRequest
    }
}
