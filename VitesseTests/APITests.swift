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
            XCTFail()
        }
    }
    
    func testCallShouldThrowCustomError() async {
        let error = API.APIError(reason: "Bad email", error: true)
        let data = try! JSONEncoder().encode(error)
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        let sessionFake = URLSessionFake(data: data, response: response)
        
        let api = API(session: sessionFake)
        
        do {
            let _ = try await api.call(endPoint: API.AuthEndPoints.auth(email: "test@vitesse.com", password: "test123")) as EmptyResponse
        } catch let error as API.Error {
            switch error {
                case .custom(let reason):
                    XCTAssertEqual(reason, "This email is already taken.")
                default:
                    XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
    
    func testCallURLResponseFailed() async {
        let response = URLResponse()
        let session = URLSessionFake(response: response)
        
        let api = API(session: session)
        
        do {
            let _ = try await api.call(endPoint: API.AuthEndPoints.auth(email: "test@vitesse.com", password: "test123")) as EmptyResponse
        } catch let error as API.Error {
            switch error {
                case .responseError:
                    print("succees")
                default:
                    XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
}

