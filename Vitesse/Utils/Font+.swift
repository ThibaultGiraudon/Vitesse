//
//  Font+.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import Foundation
import SwiftUI

extension Font {
    static func virgil(size: CGFloat = 20) -> Font? {
        return Font.custom("VirgilGS", size: size)
    }
    
    static func cascadia(size: CGFloat = 20) -> Font? {
        return Font.custom("CascadiaCode", size: size)
    }
    
}
