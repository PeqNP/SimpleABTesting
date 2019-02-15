/**
 Represents the environments the app will live in.
 
 Other common cases you may want to add to this `enum` are `preview` and `test`.
 
 License: MIT
 
 Copyright © 2019 Upstart Illustration LLC. All rights reserved.
 */

import Foundation

struct Environment: OptionSet {
    let rawValue: Int
    
    static let dev = Environment(rawValue: 1 << 0)
    static let qa = Environment(rawValue: 1 << 1)
    static let prod = Environment(rawValue: 1 << 2)
    
    static let all: Environment = [.dev, .qa, .prod]
}
