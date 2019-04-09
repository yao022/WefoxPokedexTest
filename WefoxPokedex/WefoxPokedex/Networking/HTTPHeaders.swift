//
//  HTTPHeaders.swift
//  WefoxPokedex
//
//  Created by Jordi Ferrer Pedrol on 07/04/2019.
//  Copyright © 2019 Jordi Ferrer Pedrol. All rights reserved.
//

import Foundation

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
}


