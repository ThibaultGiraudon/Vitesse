//
//  CandidateTests.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 02/04/2025.
//

import XCTest
@testable import Vitesse

@MainActor
final class CandidateTests: XCTestCase {
    func testUpdateCandidateSucceeds() async {
        let api = APIFake()
        api.data = FakeData.candidateSucceed!
        let candidate = Candidate(firstName: "Marie", lastName: "Curie", email: "marie.curie@gmail.com", phone: "06 12 12 12 12")
        let viewModel = CandidateViewModel(candidate: candidate, api: api)
        
        await viewModel.updateCandidate()
        print(viewModel.transferedMessage)
        XCTAssertEqual(viewModel.candidate.firstName, "Rima")
    }
    
    func testUpdateCandidateFailedWithInvalidEmail() async {
        let viewModel = CandidateViewModel(candidate: Candidate())
        viewModel.editedCandidate.email = "test@gmail"
        
        await viewModel.updateCandidate()
        XCTAssertEqual(viewModel.transferedMessage, "Invalid email format.")
    }
    
    func testUpdateCandidateFailedWithInvalidPhone() async {
        let viewModel = CandidateViewModel(candidate: Candidate())
        viewModel.editedCandidate.email = "test@gmail.com"
        viewModel.editedCandidate.phone = "phone"
        
        await viewModel.updateCandidate()
        XCTAssertEqual(viewModel.transferedMessage, "Invalid phone number format.")
    }
    
    func testUpdateCandidateFailedWithMissingPhone() async {
        let viewModel = CandidateViewModel(candidate: Candidate())
        viewModel.editedCandidate.email = "test@gmail.com"
        viewModel.editedCandidate.phone = nil
        
        await viewModel.updateCandidate()
        XCTAssertEqual(viewModel.transferedMessage, "Phone number is required.")
    }
    
    func testUpdateCandidateFailedWithInternalError() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = API.Error.internalServerError
        var candidate = try! JSONDecoder().decode(Candidate.self, from: FakeData.candidateSucceed!)
        candidate.phone = "06 12 12 12 12"
        let viewModel = CandidateViewModel(candidate: candidate, api: api)
        
        await viewModel.updateCandidate()
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
    }
    
    func testSetFavoriteSucceeds() async {
        let api = APIFake()
        api.data = FakeData.candidateFavoriteSucceed!
        let candidate = try! JSONDecoder().decode(Candidate.self, from: FakeData.candidateSucceed!)
        let viewModel = CandidateViewModel(candidate: candidate, api: api)
        
        XCTAssertFalse(viewModel.candidate.isFavorite)
        await viewModel.setFavorite()
        XCTAssertTrue(viewModel.candidate.isFavorite)
    }
    
    func testSetFavoriteFailedWithInternalError() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = API.Error.internalServerError
        let candidate = try! JSONDecoder().decode(Candidate.self, from: FakeData.candidateSucceed!)
        let viewModel = CandidateViewModel(candidate: candidate, api: api)
        
        await viewModel.setFavorite()
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
    }
    
    func testShouldDisable() {
        let viewModel = CandidateViewModel(candidate: Candidate())
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.editedCandidate.firstName = "Marie"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.editedCandidate.lastName = "Curie"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.editedCandidate.email = "marie.curie@gmail.com"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.editedCandidate.phone = "06 12 12 12 12"
        XCTAssertFalse(viewModel.shouldDisable)
    }
}
