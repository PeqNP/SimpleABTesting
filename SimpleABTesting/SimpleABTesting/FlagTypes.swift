/**
 Contains of all the types for your feature flag / AB tests.
 
 License: MIT
 
 Copyright © 2019 Upstart Illustration LLC. All rights reserved.
 */

import Foundation

/// A sample of a multi-variant A/B test flag type.
enum ButtonColor: String {
    case `default`
    case red
    case yellow
    case blue
    
    static func mapper(_ value: Any) -> ButtonColor? {
        guard let rawValue = value as? String else {
            return nil
        }
        return ButtonColor(rawValue: rawValue)
    }
}
