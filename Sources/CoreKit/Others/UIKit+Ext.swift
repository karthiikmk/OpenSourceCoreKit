//
//  Created by Karthik on 24/04/22.
//

import UIKit

extension UINavigationController {
    
    /// Helps to remove back button text in the navigation bar.  
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }
}

public extension Array where Element: Sequence {
    func join() -> Array<Element.Element> {
        return self.reduce([], +)
    }
}

public extension String {
    var trimWhiteAndSpace: String {
        return replacingOccurrences(of: "\n", with: "")
    }
}

public extension Double {
    
    func convert(from inputTempType: UnitTemperature = .kelvin, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: self, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)    
    }
}
