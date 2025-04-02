//
//  EndPointsFake.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 02/04/2025.
//

import Foundation
@testable import Vitesse

extension API {
    enum EndPointsFake: API.EndPoint {
        case fake
        
        var path: String { "/fake/" }
        
        var authorization: Vitesse.API.Authorization { .none }
        
        var method: Vitesse.API.Method { .get }
        
        var body: Data? { nil }
        
        var request: URLRequest? { nil }
        
        
    }
}
