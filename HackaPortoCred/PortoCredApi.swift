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
    let tax: Double
    let valueFinanced: Double
    let valueReleaded: Double
    let valueSafed: Double
    let totalValue: Double
    
    enum CodingKeys: String, CodingKey {
        case term = "prazo"
        case tax = "taxa"
        case valueFinanced = "valor-financiado"
        case valueReleaded = "valor-liberado"
        case valueSafed = "valor-seguro"
        case totalValue = "valor-total"
    }
}

struct Condition: Decodable {
    let conditions: String
    
    enum CodingKeys: String, CodingKey {
        case conditions = "texto-condicoes"
    }
}

struct CustomError: Error {
    
}


class PortoCredApi {
    static let shared = PortoCredApi()
    let clientId = "fc175b80-919c-3f91-bbe9-7932a9b870f3"
    let clientIdKey = "CLIENT_ID"
    let decoder = JSONDecoder()
    
    func getOffer(completion: @escaping (Cet?, Error?) -> Void) {
        let urlString = "https://sb-api.portocred.com.br/credito-pessoal-demo/v1/propostas/1/status"
        guard let url = URL(string: urlString) else {
            completion(nil, CocoaError(.coderInvalidValue))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = [clientIdKey: clientId]
        
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
                completion(cet, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func getConditions(completion: @escaping (Condition?, Error?) -> Void) {
        let urlString = "https://sb-api.portocred.com.br/credito-pessoal-demo/v1/propostas/1/condicoes"
        guard let url = URL(string: urlString) else {
            completion(nil, CocoaError(.coderInvalidValue))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = [clientIdKey: clientId]
        
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
                let condition = try self.decoder.decode(Condition.self, from: data)
                completion(condition, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
}
