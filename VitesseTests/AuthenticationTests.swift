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
    func testAuthenticateSucceeds() async {
        let api = APIFake()
        api.data = FakeData.loginSucceed!
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.email = "admin@vitesse.com"
        await viewModel.login()
        XCTAssertEqual(User.shared.token, "FfdfsdfdF9fdsf.fdsfdf98FDkzfdA3122.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U")
        XCTAssertTrue(User.shared.isAdmin)
    }
    
    func testAuthenticateFailedWithInternalError() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = API.Error.internalServerError
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.email = "admin@vitesse.com"
        await viewModel.login()
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func testAuthenticateFailedWithCustomError() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = API.Error.custom(reason: "Bad password")
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.email = "admin@vitesse.com"
        await viewModel.login()
        XCTAssertEqual(viewModel.transferedMessage, "Bad password")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testAuthenticateFailedWithURLError() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = URLError(.badURL)
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.email = "admin@vitesse.com"
        await viewModel.login()
        XCTAssertEqual(viewModel.alertTitle, URLError(.badURL).localizedDescription)
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func testAuthenticateFailedWithInvalidMail() async {
        let api = APIFake()
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.email = "admin@vitesse"
        await viewModel.login()
        XCTAssertEqual(viewModel.transferedMessage, "Invalid email format.")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testAuthenticateShouldDisable() async {
        let api = APIFake()
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.email = "test@vitesse.com"
        viewModel.password = "qwerty123"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        XCTAssertTrue(viewModel.shouldDisable)
    }
    
    func testRegisterSucceeds() async {
        let api = APIFake()
        api.data = FakeData.loginSucceed!
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty123"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(User.shared.token, "FfdfsdfdF9fdsf.fdsfdf98FDkzfdA3122.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U")
        XCTAssertTrue(User.shared.isAdmin)
    }
    
    func testRegisterFailedWithInternalError() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = API.Error.internalServerError
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty123"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.alertTitle, API.Error.internalServerError.localizedDescription)
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func testRegisterFailedWithCustomError() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = API.Error.custom(reason: "Bad password")
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty123"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.transferedMessage, "Bad password")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testRegisterFailedWithURLError() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = URLError(.badURL)
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty123"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.alertTitle, URLError(.badURL).localizedDescription)
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func testRegisterFailedWithPasswordMismatch() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = URLError(.badURL)
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty12"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.transferedMessage, "Passwords don't match.")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testRegisterFailedWithPasswordTooShort() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = URLError(.badURL)
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.password = "qwe"
        viewModel.confirmPassword = "qwe"
        viewModel.email = "admin@vitesse.com"
        await viewModel.register()
        XCTAssertEqual(viewModel.transferedMessage, "Password must be at least 6 characters long.")
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testRegisterFailedWithInvalidEmail() async {
        let api = APIFake()
        api.shouldSucceed = false
        api.error = URLError(.badURL)
        let viewModel = AuthenticationViewModel(api: api)
        
        viewModel.password = "qwerty123"
        viewModel.confirmPassword = "qwerty123"
        viewModel.email = "admin@vitesse"
        await viewModel.register()
        XCTAssertEqual(viewModel.transferedMessage, "Invalid email format.")
        XCTAssertFalse(viewModel.showAlert)
    }
}
