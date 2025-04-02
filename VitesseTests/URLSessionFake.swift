//
//  URLSessionFake.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 26/03/2025.
//

import Foundation
@testable import Vitesse

class URLSessionFake: URLSessionProtocol {
    var fakeData: Data?
    var fakeResponse: URLResponse?
    var error: Error?
    
    init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.fakeData = data
        self.fakeResponse = response
        self.error = error
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        let data = fakeData ?? Data()
        let response = fakeResponse ?? HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        return (data, response)
    }
}
