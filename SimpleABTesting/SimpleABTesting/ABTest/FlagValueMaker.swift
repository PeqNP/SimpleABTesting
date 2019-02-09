/**
 Common types that can be transformed from a String value.
 
 This is used specifically by the `Flag` to convert a value from the server into its respective value.
 
 There is an assumption that the only types that will be used for flags are `Bool`s, `String`s, `Int`s, and `Double`s.
 
 Enums should have their own mapper and could use `init(rawValue:)` if they are `RawRepresentable`.
 
 Please note that `String` doesn't need to be a `FlagValueMaker` as the value is a `String` will pass the `value as? T` condition in `Flag.setValue(_:)`.
 
 License: MIT
 
 Copyright © 2019 Upstart Illustration LLC. All rights reserved.
 */

import Foundation

protocol FlagValueMaker {
    func make(from string: String) -> Self?
}

// MARK: - Extensions

extension Bool: FlagValueMaker {
    func make(from string: String) -> Bool? {
        // This initializer works so long as the value is either `"true"` or `"false"`
        return Bool(string.lowercased())
    }
}

extension Double: FlagValueMaker {
    func make(from string: String) -> Double? {
        return Double(string)
    }
}

extension Int: FlagValueMaker {
    func make(from string: String) -> Int? {
        return Int(string)
    }
}
