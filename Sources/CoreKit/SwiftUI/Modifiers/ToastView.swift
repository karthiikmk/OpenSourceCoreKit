//
//  Created by Karthik on 07/04/22.
//

import Foundation
import SwiftUI

public struct ToastView<T: View>: ViewModifier {
    @Binding public var showToast: Bool
    @State public var timer: Timer?
    public let toastContent: T    
    public let duration: TimeInterval
    public let position: ToastPosition
    
    public enum ToastPosition{
        case top, middle, bottom
    }
    
    public func body(content: Content) -> some View {
        GeometryReader{ geo in            
            ZStack{
                content
                if showToast {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .shadow(radius: 10)
                        .overlay(toastContent.minimumScaleFactor(0.2))
                        .frame(maxWidth: geo.size.width*0.4, maxHeight: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)                    
                        .position(x: geo.size.width/2, y: getYPosition(height: geo.size.height, safeAreaInset: geo.safeAreaInsets))
                        .onAppear(perform: { 
                            timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: {_ in
                                showToast = false
                            })
                        })
                        .onDisappear(perform: { 
                            timer?.invalidate()
                            timer = nil
                        })
                }
            }.onTapGesture {
                showToast = false
            }
        }        
    }
    
    private func getYPosition(height: CGFloat, safeAreaInset: EdgeInsets) -> CGFloat{
        var result: CGFloat = 0
        if position == .top{
            result = 0 + safeAreaInset.top
        }else if position == .bottom{
            result = height - safeAreaInset.bottom
        }else if position == .middle{
            result = height/2
        }
        return result
    }
}
