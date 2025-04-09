//
//  AuthenticationTests.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 27/03/2025.
//

import XCTest
@testable import Vitesse

@MainActor
final class AuthenticationTests: XCTestCase {
    func testRegisterSucceeds() async {
        let session = URLSessionFake(data: FakeData.loginSucceed)
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.email = "test@vitesse.com"
        viewModel.firstName = "Test"
        viewModel.lastName = "Test"
        viewModel.password = "test123"
        viewModel.confirmPassword = "test123"
        await viewModel.register()
        XCTAssertEqual(User.shared.token, "FfdfsdfdF9fdsf.fdsfdf98FDkzfdA3122.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U")
        XCTAssertTrue(User.shared.isAdmin)
    }
    
    func testLoginFailedWithInternalError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.email = "admin@vitesse.com"
        await viewModel.login()
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func testLoginFailedWithCustomError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Bad password", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.email = "admin@vitesse.com"
        await viewModel.login()
        XCTAssertEqual(viewModel.transferedMessage, "Bad password")
        XCTAssertFalse(viewModel.showAlert)
    }

    
    func testLoginFailedWithInvalidMail() async {
        let session = URLSessionFake()
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.email = "admin@vitesse"
        await viewModel.login()
        XCTAssertEqual(viewModel.transferedMessage, "Invalid email format.")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testLoginShouldDisable() async {
        let session = URLSessionFake()
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.email = "test@vitesse.com"
        viewModel.password = "qwerty123"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        XCTAssertTrue(viewModel.shouldDisable)
    }

    
    func testRegisterFailedWithInternalError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Email already in use", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty123"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func testRegisterFailedWithCustomError() async {
        let response = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        let apiError = API.APIError(reason: "Bad password", error: true)
        let data = try! JSONEncoder().encode(apiError)
        let session = URLSessionFake(data: data, response: response)
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty123"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.transferedMessage, "Bad password")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testRegisterFailedWithPasswordMismatch() async {
        let session = URLSessionFake()
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty12"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.transferedMessage, "Passwords don't match.")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testRegisterFailedWithPasswordTooShort() async {
        let session = URLSessionFake()
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.password = "qwe"
        viewModel.confirmPassword = "qwe"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.transferedMessage, "Password must be at least 6 characters long.")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testRegisterFailedWithInvalidEmail() async {
        let session = URLSessionFake()
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty123"
        viewModel.email = "admin@vitesse"
        await viewModel.register()
        XCTAssertEqual(viewModel.transferedMessage, "Invalid email format.")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testRegisterFailedWithBadURL() async {
        let session = URLSessionFake()
        session.error = URLError(.badURL)
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty123"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.alertTitle, URLError(.badURL).localizedDescription)
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func testLoginFailedWithBadURL() async {
        let session = URLSessionFake()
        session.error = URLError(.badURL)
        let viewModel = AuthenticationViewModel(session: session)
        
        viewModel.password = "qwerty123"
        viewModel.email = "admin@vitesse.com"
        await viewModel.login()
        XCTAssertEqual(viewModel.alertTitle, URLError(.badURL).localizedDescription)
        XCTAssertTrue(viewModel.showAlert)
    }
}
