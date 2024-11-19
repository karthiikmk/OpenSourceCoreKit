//
//  Spacing.swift
//  WSUIKit
//
//  Created by Karthik MK on 31/07/24.
//

import Foundation

/// Predefined Wrkspot spacing to help making interface clear and easy to scan.
public enum Spacing: CGFloat {
    /// 2 pts.
    case xxxSmall = 2
    /// 4 pts.
    case xxSmall = 4
    /// 8 pts.
    case xSmall = 8
    /// 12 pts.
    case small = 12
    /// 16 pts.
    case medium = 16
    /// 20 pts.
    case xMedium = 20
    /// 24 pts.
    case large = 24
    /// 32 pts.
    case xLarge = 32
    /// 44 pts.
    case xxLarge = 44
    /// 60 pts.
    case xxxLarge = 60
}

public extension CGFloat {
    /// Wrkspot 2 pts spacing.
    static let xxxSmall = Spacing.xxxSmall.rawValue
    /// Wrkspot 4 pts spacing.
    static let xxSmall = Spacing.xxSmall.rawValue
    /// Wrkspot 8 pts spacing.
    static let xSmall = Spacing.xSmall.rawValue
    /// Wrkspot 12 pts spacing.
    static let small = Spacing.small.rawValue
    /// Wrkspot 16 pts spacing.
    static let medium = Spacing.medium.rawValue
    /// Wrkspot 20 pts spacing.
    static let xMedium = Spacing.xMedium.rawValue
    /// Wrkspot 24 pts spacing.
    static let large = Spacing.large.rawValue
    /// Wrkspot 32 pts spacing.
    static let xLarge = Spacing.xLarge.rawValue
    /// Wrkspot 44 pts spacing.
    static let xxLarge = Spacing.xxLarge.rawValue
    /// Wrkspot 60 pts spacing.
    static let xxxLarge = Spacing.xxxLarge.rawValue
}
