//
//  File.swift
//  CoreKit
//
//  Created by Karthik on 19/11/24.
//

import Foundation
import SwiftUI

public extension Image {
    
    static let trayIcon = Image(systemName: "tray")
    static let xmarkCircleFillIcon = Image(systemName: "xmark.circle.fill")
    static let settingsCirleFillIcon = Image(systemName: "ellipsis.circle.fill")
    static let bookmarkCircleFillIcon = Image(systemName: "bookmark.circle.fill")
    static let personCirleIcon = Image(systemName: "person.crop.circle")
}

private struct ImagePreviewView: View {
    
    var body: some View {
        HStack(spacing: .small) {
            Image.trayIcon
            Image.xmarkCircleFillIcon
            Image.settingsCirleFillIcon
            Image.bookmarkCircleFillIcon
            Image.personCirleIcon
        }
        .foregroundColor(Color.gray)
    }
}

#Preview {
    ImagePreviewView()
}
