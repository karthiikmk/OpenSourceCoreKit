//
//  Color+.swift
//  iOSInterviewGuide-SwiftUI
//
//  Created by Karthik on 19/11/24.
//

import Foundation
import SwiftUI

// - MARK: Color+
public extension Color {
    static var primaryTextColor: Color { fromResource(named: "text_primary_color") }
    static var secondaryTextColor: Color { fromResource(named: "text_secondary_color") }
    static var successColor: Color { fromResource(named: "success_color") }
    static var randomColor: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    private static func fromResource(named: String) -> Color {
        return Color(named, bundle: .module)
    }
}

// - MARK: UIColor+
public extension UIColor {
    static let primaryTextColor = fromResource(named: "text_primary_color")
    static let secondaryTextColor = fromResource(named: "text_secondary_color")
    
    private static func fromResource(named: String) -> UIColor {
        return UIColor(named: named, in: .module, compatibleWith: nil)!
    }
}

// - MARK: ShapeStyle+
@available(iOS 15.0, *)
extension ShapeStyle where Self == Color {
    public static var primaryTextColor: Color { Color.primaryTextColor }
    public static var secondaryTextColor: Color { .secondaryTextColor }
    public static var successColor: Color { .successColor }
    public static var randomColor: Color { .randomColor }
}
