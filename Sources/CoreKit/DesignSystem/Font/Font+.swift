//
//  Font.swift
//  iOSInterviewGuide-SwiftUI
//
//  Created by Karthik on 19/11/24.
//

import Foundation

public enum FontType {
    
    /// Regular font type with specified size.
    case regular(size: CGFloat)
    
    /// Medium font type with specified size.
    case medium(size: CGFloat)
    
    /// Semibold font type with specified size.
    case semibold(size: CGFloat)
    
    /// Bold font type with specified size.
    case bold(size: CGFloat)
    
    var size: CGFloat {
        switch self {
        case .regular(let size),
                .medium(let size),
                .semibold(let size),
                .bold(let size):
            return size
        }
    }
    
    var type: String {
        switch self {
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "SemiBold"
        case .bold: return "Bold"
        }
    }
}
