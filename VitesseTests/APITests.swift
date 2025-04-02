//
//  APITests.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 26/03/2025.
//

import XCTest
@testable import Vitesse

final class APITests: XCTestCase {
    func testLoginSucceeds() async {
        let sessionFake = URLSessionFake(data: FakeData.loginSucceed)
        let api = API(session: sessionFake)
        
        do {
            let token: Token = try await api.call(endPoint: API.AuthEndPoints.auth(email: "test", password: "test"))
            XCTAssertEqual(token.token, "FfdfsdfdF9fdsf.fdsfdf98FDkzfdA3122.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U")
            XCTAssertTrue(token.isAdmin)
        } catch {
            XCTFail("No error should be thrown\n\(error.localizedDescription)")
        }
    }
    
    func testRegisterSucceeds() async {
        let sessionFake = URLSessionFake(data: FakeData.loginSucceed)
        let api = API(session: sessionFake)
        
        do {
            try await api.call(endPoint: API.AuthEndPoints.register(email: "", password: "", firstName: "", lastName: ""))
        } catch {
            XCTFail("No error should be thrown\n\(error.localizedDescription)")
        }
    }
    
    func testGetCandidateSucceeds() async {
        let sessionFake = URLSessionFake(data: FakeData.candidatesSucceed)
        let api = API(session: sessionFake)
        
        do {
            let candidates: [Candidate] = try await api.call(endPoint: API.CandidatesEndPoints.candidate(id: nil))
            guard let candidate = candidates.first else {
                XCTFail("Candidates should not be empty")
                return
            }
            XCTAssertEqual(candidate.id, "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1")
        } catch {
            XCTFail("No error should be thrown\n\(error.localizedDescription)")
        }
    }
    
    func testGetCandidateIDSucceeds() async {
        let sessionFake = URLSessionFake(data: FakeData.candidatesSucceed)
        let api = API(session: sessionFake)
        
        do {
            let candidates: [Candidate] = try await api.call(endPoint: API.CandidatesEndPoints.candidate(id: "0"))
            guard let candidate = candidates.first else {
                XCTFail("Candidates should not be empty")
                return
            }
            XCTAssertEqual(candidate.id, "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1")
        } catch {
            XCTFail("No error should be thrown\n\(error.localizedDescription)")
        }
    }
    
    func testCreateCandidateSucceeds() async {
        let sessionFake = URLSessionFake(data: FakeData.candidatesSucceed)
        let api = API(session: sessionFake)
        
        let newCandidate = Candidate()
        
        do {
            let candidates: [Candidate] = try await api.call(endPoint: API.CandidatesEndPoints.createCandidate(candidate: newCandidate))
            guard let candidate = candidates.first else {
                XCTFail("Candidates should not be empty")
                return
            }
            XCTAssertEqual(candidate.id, "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1")
        } catch {
            XCTFail("No error should be thrown\n\(error.localizedDescription)")
        }
    }
    
    func testDeleteCandidateSucceeds() async {
        let sessionFake = URLSessionFake()
        let api = API(session: sessionFake)
        
        do {
            try await api.call(endPoint: API.CandidatesEndPoints.delete(id: "0"))
        } catch {
            XCTFail("No error should be thrown\n\(error.localizedDescription)")
        }
    }
    
    func testUpdateCandidateSucceeds() async {
        let sessionFake = URLSessionFake(data: FakeData.candidatesSucceed)
        let api = API(session: sessionFake)
        
        let updateCandidate = Candidate()
        
        do {
            let candidates: [Candidate] = try await api.call(endPoint: API.CandidatesEndPoints.update(candidate: updateCandidate))
            guard let candidate = candidates.first else {
                XCTFail("Candidates should not be empty")
                return
            }
            XCTAssertEqual(candidate.id, "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1")
        } catch {
            XCTFail("No error should be thrown\n\(error.localizedDescription)")
        }
    }
    
    func testToggleCandidateSucceeds() async {
        let sessionFake = URLSessionFake(data: FakeData.candidatesSucceed)
        let api = API(session: sessionFake)
        
        do {
            let candidates: [Candidate] = try await api.call(endPoint: API.CandidatesEndPoints.favorite(id: "0"))
            guard let candidate = candidates.first else {
                XCTFail("Candidates should not be empty")
                return
            }
            XCTAssertEqual(candidate.id, "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1")
        } catch {
            XCTFail("No error should be thrown\n\(error.localizedDescription)")
        }
    }
    
    func testCallShouldThrowCustomError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let sessionFake = URLSessionFake(data: data, response: response)
        
        let api = API(session: sessionFake)
        
        do {
            let _ = try await api.call(endPoint: API.CandidatesEndPoints.candidate(id: nil)) as [Candidate]
        } catch let error as API.Error where error == .custom(reason: "Email already in use") {
            
        } catch {
            XCTFail()
        }
    }
    
    func testCallShouldThrowNotFoundError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let sessionFake = URLSessionFake(data: data, response: response)
        
        let api = API(session: sessionFake)
        
        do {
            let _ = try await api.call(endPoint: API.CandidatesEndPoints.candidate(id: nil)) as [Candidate]
        } catch let error as API.Error where error == .notFound {
            
        } catch {
            XCTFail()
        }
    }
    
    func testCallShouldThrowInternalError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let sessionFake = URLSessionFake(data: data, response: response)
        
        let api = API(session: sessionFake)
        
        do {
            let _ = try await api.call(endPoint: API.CandidatesEndPoints.candidate(id: nil)) as [Candidate]
        } catch let error as API.Error where error == .internalServerError {
            
        } catch {
            XCTFail()
        }
    }
    
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
    
    func testCallWithoutResponseShouldThrowCustomError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let sessionFake = URLSessionFake(data: data, response: response)
        
        let api = API(session: sessionFake)
        
        do {
            try await api.call(endPoint: API.CandidatesEndPoints.candidate(id: nil))
        } catch let error as API.Error where error == .custom(reason: "Email already in use") {
            
        } catch {
            XCTFail()
        }
    }
    
    func testCallWithoutResponseShouldThrowNotFoundError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let sessionFake = URLSessionFake(data: data, response: response)
        
        let api = API(session: sessionFake)
        
        do {
            try await api.call(endPoint: API.CandidatesEndPoints.candidate(id: nil))
        } catch let error as API.Error where error == .notFound {
            
        } catch {
            XCTFail()
        }
    }
    
    func testCallWithoutResponseShouldThrowInternalError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let sessionFake = URLSessionFake(data: data, response: response)
        
        let api = API(session: sessionFake)
        
        do {
            try await api.call(endPoint: API.CandidatesEndPoints.candidate(id: nil))
        } catch let error as API.Error where error == .internalServerError {
            
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

