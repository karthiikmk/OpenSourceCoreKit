//
//  Color+.swift
//  iOSInterviewGuide-SwiftUI
//
//  Created by Karthik on 19/11/24.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    
    public static var primaryTextColor: Color { fromResource(named: "text_primary_color") }
    public static var secondaryTextColor: Color { fromResource(named: "text_secondary_color") }
    
    static func fromResource(named: String) -> Color {
        let bundle = Bundle(for: DesignSystem.self)
        return Color(named, bundle: bundle)
    }
}
