//
//  TextFieldStyle.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 09/04/2025.
//

import SwiftUI

struct TextFieldStyle: ViewModifier {
    var length: CGFloat
    var keyboardType: UIKeyboardType
    func body(content: Content) -> some View {
        content
            .padding(length)
            .background {
                RoundedRectangle(cornerRadius: 2)
                    .stroke()
            }
            .keyboardType(keyboardType)
            .autocorrectionDisabled(keyboardType != .default)
            .textInputAutocapitalization(keyboardType != .default ? .never : .sentences)
    }
}

extension View {
    func textFieldStyle(_ length: CGFloat = 5, keyboardType: UIKeyboardType = .default) -> some View {
        modifier(TextFieldStyle(length: length, keyboardType: keyboardType))
    }
}
