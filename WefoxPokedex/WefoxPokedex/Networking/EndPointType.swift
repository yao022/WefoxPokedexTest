//
//  EndPointType.swift
//  WefoxPokedex
//
//  Created by Jordi Ferrer Pedrol on 07/04/2019.
//  Copyright © 2019 Jordi Ferrer Pedrol. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}


