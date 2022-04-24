//
//  FeedListErrorPlaceHolderView.swift
//  AvomaFeed
//
//  Created by Karthik on 05/04/22.
//

import SwiftUI

public struct PlaceHolderView: View {
    public var type: PlaceHolderType
    public init(type: PlaceHolderType) {
        self.type = type
    }
    
    public var body: some View {
        VStack {
            Image(systemName: type.icon)
                .font(Font.system(.largeTitle).bold())
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundColor(.red)
            VStack(spacing: 5) {
                Text(type.message.title)
                    .font(.headline)
                    .foregroundColor(Color.subHeadlineColor)
                Text(type.message.desc)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)    
            }           
        }        
    }
}

struct PlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceHolderView(type: .error)
    }
}
