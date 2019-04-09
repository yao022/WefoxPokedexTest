//
//  PokeApiEndpoint.swift
//  WefoxPokedex
//
//  Created by Jordi Ferrer Pedrol on 07/04/2019.
//  Copyright © 2019 Jordi Ferrer Pedrol. All rights reserved.
//

import Foundation


enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum PokeApi {
    case pokemon(id:Int)
   
}

extension PokeApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://pokeapi.co/api/v2/"
        case .qa: return "https://pokeapi.co/api/v2/"
        case .staging: return "https://pokeapi.co/api/v2/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .pokemon(let id):
            return "pokemon/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .pokemon(let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["id":id])
       
   
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


