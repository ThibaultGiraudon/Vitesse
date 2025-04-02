//
//  VitesseTests.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 26/03/2025.
//

import XCTest
@testable import Vitesse

final class VitesseTests: XCTestCase {
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
}
