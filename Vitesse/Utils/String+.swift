//
//  String+.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let phoneRegex = #"^(\+33+[ -.]?)?0[6-7]+([ -.]?+\d{2}){4}$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self)
    }
}
