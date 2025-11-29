//
//  Animations.swift
//  Bloom
//
//  Design system animations
//

import SwiftUI

extension Animation {
    // MARK: - Standard Animations
    static let bloomQuick = Animation.easeOut(duration: 0.2)
    static let bloomStandard = Animation.easeInOut(duration: 0.3)
    static let bloomSmooth = Animation.spring(response: 0.4, dampingFraction: 0.8)
    static let bloomBouncy = Animation.spring(response: 0.5, dampingFraction: 0.6)
}
