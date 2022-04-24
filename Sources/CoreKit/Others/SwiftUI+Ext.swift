//
//  Created by Karthik on 24/04/22.
//

import Foundation
import SwiftUI

extension Color {
    static var subHeadlineColor: Color {
        Color("color_subheadline", bundle: .module)
    }
}

struct EmptyDataModifier<Placeholder: View>: ViewModifier {
    
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

public extension List {    
    func emptyListPlaceholder(_ items: [Any], _ placeholder: AnyView) -> some View {
        modifier(EmptyDataModifier(items: items, placeholder: placeholder))
    }
}

/// Using ViewModifier to add the toast on top of caller view.
public extension View {
    func toast<T:View>(
        showToast: Binding<Bool>,
        duration: TimeInterval = 5,
        position: ToastView<T>.ToastPosition = .top,
        @ViewBuilder toastContent: @escaping () -> T
    ) -> some View {
        modifier(ToastView(
            showToast: showToast,
            toastContent: toastContent(),
            duration: duration,
            position: position
        ))        
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

public extension View {
    func navigatePush(whenTrue toggle: Binding<Bool>) -> some View {
        NavigationLink(
            destination: self,
            isActive: toggle
        ) { EmptyView() }
    }
    
    func navigatePush<H: Hashable>(
        when binding: Binding<H>,
        matches: H
    ) -> some View {
        NavigationLink(
            destination: self,
            tag: matches,
            selection: Binding<H?>(binding)
        ) { EmptyView() }
    }
    
    func navigatePush<H: Hashable>(
        when binding: Binding<H?>,
        matches: H
    ) -> some View {
        NavigationLink(
            destination: self,
            tag: matches,
            selection: binding
        ) { EmptyView() }
    }
}
