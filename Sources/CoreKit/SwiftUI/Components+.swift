//
//  File.swift
//  CoreKit
//
//  Created by Karthik on 19/11/24.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
public struct ActivityIndicatorView: View {
    let scale: CGFloat
    public init(scale: CGFloat = 1.5) {
        self.scale = scale
    }
    public var body: some View {
        ProgressView()
            .scaleEffect(scale, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle())
    }
}

@available(iOS 15.0, *)
public struct LoaderView: View {
    let text: String
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        VStack(spacing: .xSmall) {
            ActivityIndicatorView()
            Text(text)
                .font(.title3)
                .foregroundStyle(.primaryTextColor)
        }
    }
}

/// A view that displays a placeholder with an icon, title, and description.
/// - Parameters:
///   - icon: A closure that returns the icon view to display.
///   - title: The title text to display.
///   - description: The description text to display.
///
@available(iOS 15.0, *)
public struct PlaceHolderView<Icon: View>: View {
    
    /// A closure that returns the icon view to display.
    var icon: () -> Icon
    
    /// The title text to display.
    var title: String
    
    /// The description text to display.
    var description: String
    
    public init(@ViewBuilder icon: @escaping () -> Icon, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }
    
    /// The body of the `PlaceholderView`.
    public var body: some View {
        VStack(spacing: .xSmall) {
            icon()
            Text(title)
                .font(.title)
                .foregroundStyle(.primaryTextColor)
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondaryTextColor)
        }
    }
}


#Preview {
    if #available(iOS 15.0, *) {
        LoaderView(text: "Loading")
    } else {
        // Fallback on earlier versions
    }
}
