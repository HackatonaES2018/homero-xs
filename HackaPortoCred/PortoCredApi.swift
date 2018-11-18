//
//  PortoCredApi.swift
//  HackaPortoCred
//
//  Created by Homero Oliveira on 17/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import Foundation

struct OfferResponse: Decodable {
    let offers: [Offer]
    
    enum CodingKeys: String, CodingKey {
        case offers = "ofertas"
    }
}

struct Offer: Decodable {
    let cet: Cet
}

struct Cet: Decodable {
    let term: Int
    let valueFinanced: Double
    let valueReleaded: Double
    let valueSafed: Double
    let totalValue: Double
    
    enum CodingKeys: String, CodingKey {
        case term = "taxa"
        case valueFinanced = "valor-financiado"
        case valueReleaded = "valor-liberado"
        case valueSafed = "valor-seguro"
        case totalValue = "valor-total"
    }
}

struct CustomError: Error {
    
}


class PortoCredApi {
    static let shared = PortoCredApi()
    let clientId = "fc175b80-919c-3f91-bbe9-7932a9b870f3"
    let clientIdKey = "CLIENT_ID"
    let decoder = JSONDecoder()
    
    func getOferta(completion: @escaping (Offer?, Error?) -> Void) {
        let urlString = "https://sb-api.portocred.com.br/credito-pessoal-demo/v1/propostas/1/status"
        guard let url = URL(string: urlString) else {
            completion(nil, CocoaError(.coderInvalidValue))
            return
        }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, CustomError())
                }
                return
            }
            
            do {
                let offerResponse = try self.decoder.decode(OfferResponse.self, from: data)
                let cet = offerResponse.offers.first!.cet
                
            } catch {
                
            }
        }
    }
}
