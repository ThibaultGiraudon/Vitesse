//
//  CandidatesTests.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 27/03/2025.
//

import XCTest
import SwiftUI
@testable import Vitesse

@MainActor
final class CandidatesTests: XCTestCase {

    func testFetchCandidatesSucceeds() async {
        let session = URLSessionFake(data: FakeData.candidatesSucceed)
        let viewModel = CandidatesViewModel(session: session)
        
        await viewModel.fetchCandidates()
        guard let candidate = viewModel.candidates.first else {
            XCTFail("Candidates should have items")
            return
        }
        XCTAssertEqual(candidate.id, "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1")
        XCTAssertEqual(candidate.fullName, "Rima S.")
    }
    
    func testFetchCandidatesFailedWithInternalError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = CandidatesViewModel(session: session)
        
        await viewModel.fetchCandidates()
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
    }
    
    func testFetchCandidatesFailedWithNotFound() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = CandidatesViewModel(session: session)
        
        await viewModel.fetchCandidates()
        XCTAssertEqual(viewModel.alertTitle, API.Error.notFound.localizedDescription)
    }
    
    func testCreateCandidateSucceeds() async {
        let session = URLSessionFake(data: FakeData.candidateSucceed)
        let viewModel = CandidatesViewModel(session: session)
        
        var newCandidate = Candidate()
        newCandidate.phone = "0612121212"
        newCandidate.email = "admin@vitesse.com"
        
        await viewModel.createCandidate(newCandidate)
        guard let candidate = viewModel.candidates.first else {
            XCTFail("Candidates should have items")
            return
        }
        XCTAssertEqual(candidate.id, "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1")
        XCTAssertEqual(candidate.fullName, "Rima S.")
    }
    
    func testCreateCandidateFailedWithInternalError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = CandidatesViewModel(session: session)
        
        var newCandidate = Candidate()
        newCandidate.phone = "0612121212"
        newCandidate.email = "admin@vitesse.com"
        
        await viewModel.createCandidate(newCandidate)
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
    }
    
    func testCreateCandidateFailedWithInvalidMail() async {
        let session = URLSessionFake()
        let viewModel = CandidatesViewModel(session: session)
        
        var newCandidate = Candidate()
        newCandidate.phone = "0612121212"
        newCandidate.email = "admin@vitesse"
        
        await viewModel.createCandidate(newCandidate)
        XCTAssertEqual(viewModel.transferedMessage, "Invalid email format")
    }
    
    func testCreateCandidateFailedWithInvalidPhone() async {
        let session = URLSessionFake()
        let viewModel = CandidatesViewModel(session: session)
        
        var newCandidate = Candidate()
        newCandidate.phone = "0612121"
        newCandidate.email = "admin@vitesse.com"
        
        await viewModel.createCandidate(newCandidate)
        XCTAssertEqual(viewModel.transferedMessage, "Invalid phone number format")
    }
    
    func testCreateCandidateFailedWithNoPhone() async {
        let session = URLSessionFake()
        let viewModel = CandidatesViewModel(session: session)
        
        var newCandidate = Candidate()
        newCandidate.phone = nil
        newCandidate.email = "admin@vitesse.com"
        
        await viewModel.createCandidate(newCandidate)
        XCTAssertEqual(viewModel.transferedMessage, "The phone number is required")
    }
    
    func testDeleteCandidatesSuccess() async {
        let session = URLSessionFake()
        let viewModel = CandidatesViewModel(session: session)
        viewModel.selectedCandidates = try! JSONDecoder().decode([Candidate].self, from: FakeData.candidatesSucceed!)
        viewModel.candidates = viewModel.selectedCandidates
        
        XCTAssertEqual(viewModel.candidates.count, 1)
        
        await viewModel.deleteCandidates()
        XCTAssertEqual(viewModel.candidates.count, 0)
    }
    
    func testDeleteCandidatesFailedCantFindCandidate() async {
        let session = URLSessionFake()
        let viewModel = CandidatesViewModel(session: session)
        viewModel.candidates = try! JSONDecoder().decode([Candidate].self, from: FakeData.candidatesSucceed!)
        
        viewModel.selectedCandidates = [Candidate()]
        
        XCTAssertEqual(viewModel.candidates.count, 1)
        
        await viewModel.deleteCandidates()
        XCTAssertEqual(viewModel.candidates.count, 1)
    }
    
    func testDeleteCandidatesFailedwithInternalError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = CandidatesViewModel(session: session)
        viewModel.selectedCandidates = try! JSONDecoder().decode([Candidate].self, from: FakeData.candidatesSucceed!)
        viewModel.candidates = viewModel.selectedCandidates
        
        XCTAssertEqual(viewModel.candidates.count, 1)
        
        await viewModel.deleteCandidates()
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
        XCTAssertEqual(viewModel.candidates.count, 1)
    }
    
    func testDeleteCandidateSuccess() async {
        let session = URLSessionFake()
        let viewModel = CandidatesViewModel(session: session)
        let candidates = try! JSONDecoder().decode([Candidate].self, from: FakeData.candidatesSucceed!)
        viewModel.candidates = candidates
        
        XCTAssertEqual(viewModel.candidates.count, 1)
        
        await viewModel.deleteCandidate(at: IndexSet(integer: 0))
        XCTAssertEqual(viewModel.candidates.count, 0)
    }
    
    func testDeleteCandidateFailedwithInternalError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = CandidatesViewModel(session: session)
        viewModel.candidates = try! JSONDecoder().decode([Candidate].self, from: FakeData.candidatesSucceed!)
        
        XCTAssertEqual(viewModel.candidates.count, 1)
        
        await viewModel.deleteCandidate(at: IndexSet(integer: 0))
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
        XCTAssertEqual(viewModel.candidates.count, 1)
    }
    
    func testSetFavoriteSucceeds() async {
        let session = URLSessionFake(data: FakeData.candidateFavoriteSucceed)
        let viewModel = CandidatesViewModel(session: session)
        let candidate = try! JSONDecoder().decode(Candidate.self, from: FakeData.candidateSucceed!)
        viewModel.candidates = try! JSONDecoder().decode([Candidate].self, from: FakeData.candidatesSucceed!)
        
        await viewModel.setFavorite(for: candidate)
        XCTAssertEqual(viewModel.candidates[0].isFavorite, true)
    }
    
    func testSetFavoriteFailedWithCantFindCandidate() async {
        let session = URLSessionFake(data: FakeData.candidateFavoriteSucceed)
        let viewModel = CandidatesViewModel(session: session)
        let candidate = try! JSONDecoder().decode(Candidate.self, from: FakeData.candidateFavoriteSucceed!)
        
        await viewModel.setFavorite(for: candidate)
    }
    
    func testSetFavoriteFailedwithInternalError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = CandidatesViewModel(session: session)
        let candidate = try! JSONDecoder().decode(Candidate.self, from: FakeData.candidateSucceed!)
        
        await viewModel.setFavorite(for: candidate)
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
    }
    
    func testFilteredCandidates() {
        let viewModel = CandidatesViewModel()
        viewModel.candidates = try! JSONDecoder().decode([Candidate].self, from: FakeData.candidatesSucceed!)
        
        
        XCTAssertEqual(viewModel.filteredCandidates.count, 1)
        viewModel.searchText = "Jo"
        XCTAssertEqual(viewModel.filteredCandidates.count, 0)
        viewModel.showFavorites = true
        XCTAssertEqual(viewModel.filteredCandidates.count, 0)
        viewModel.searchText = "Rima"
        XCTAssertEqual(viewModel.filteredCandidates.count, 0)
        viewModel.showFavorites = false
        viewModel.searchText = "Rima"
        XCTAssertEqual(viewModel.filteredCandidates.count, 1)
        viewModel.searchText = "Sidi"
        XCTAssertEqual(viewModel.filteredCandidates.count, 1)
    }
}
