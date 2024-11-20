//
//  TextSize.swift
//  WSUIKit
//
//  Created by Karthik MK on 31/07/24.
//

import Foundation

/// WrkSpot predefined ``Text`` font size.
enum TextSize: Equatable {
    /// 10 pts.
    case small
    /// 12 pts.
    case normal
    /// 14 pts.
    case large
    /// 16 pts.
    case xLarge
    
    /// Value of WrkSpot `Text` ``Text/Size``.
    public var value: CGFloat {
        switch self {
            case .small: return 10
            case .normal: return 12
            case .large: return 14
            case .xLarge: return 16
        }
    }
}
