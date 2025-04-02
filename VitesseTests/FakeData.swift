//
//  FakeData.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 26/03/2025.
//

import Foundation

class FakeData {
    static var loginSucceed: Data? = getData(for: "Login", with: "json")
    static var candidatesSucceed: Data? = getData(for: "Candidates", with: "json")
    static var candidateSucceed: Data? = getData(for: "Candidate", with: "json")
    static var candidateFavoriteSucceed: Data? = getData(for: "CandidateFavorite", with: "json")
    
}

private func getData(for resource: String, with extension: String) -> Data? {
    let bundle = Bundle(for: FakeData.self)
    let url = bundle.url(forResource: resource, withExtension: `extension`)
    guard let url = url else {
        print("Can't find \(resource).\(`extension`)")
        return nil
    }
    return try! Data(contentsOf: url)
}
