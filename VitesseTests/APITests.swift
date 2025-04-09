//
//  APITests.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 26/03/2025.
//

import XCTest
@testable import Vitesse

final class APITests: XCTestCase {
    func testCallShouldThrowBadRequest() async {
        let sessionFake = URLSessionFake()
        
        let api = API(session: sessionFake)
        
        do {
            let _ = try await api.call(endPoint: API.EndPointsFake.fake) as [Candidate]
        } catch let error as API.Error where error == .badRequest {
            
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testCallWithoutResponseShouldThrowBadRequest() async {
        let sessionFake = URLSessionFake()
        
        let api = API(session: sessionFake)
        
        do {
            try await api.call(endPoint: API.EndPointsFake.fake)
        } catch let error as API.Error where error == .badRequest {
            
        } catch {
            print(error)
            XCTFail()
        }
    }
}

