//
//  SwiftUI+Modifier.swift
//  iOSInterviewGuide-SwiftUI
//
//  Created by Karthik on 19/11/24.
//

import SwiftUI

// - MARK: Modifiers
public extension List {
    func emptyPlaceholder<Placeholder: View>(_ items: [Any], _ placeholder: Placeholder) -> some View {
        modifier(EmptyDataModifier(items: items, placeholder: placeholder))
    }
}

public extension View {
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnFirstAppear(action: action))
    }
}

// - MARK: Modifier Implementation
private struct OnFirstAppear: ViewModifier {
    @State private var hasAppeared = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                hasAppeared = true
                action?()
            }
        }
    }
}

private struct EmptyDataModifier<Placeholder: View>: ViewModifier {
    let items: [Any]
    let placeholder: Placeholder
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if !items.isEmpty {
            content
        } else {
            placeholder
        }
    }
}
