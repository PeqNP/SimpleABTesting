/**
 Provides API for a feature flag.
 
 This struct provides a way to identify a server key associated to the A/B or feature flag, a default value when a value isn't set (for a given environment), and closure to map a custom value (an enum rawValue for instance) to its respective type from a value provided by the server.
 
 The `FlagSetter` and `FlagGetter` are ways to get around the generic constraints imposed by Swift when attempting to store a collection of `Flag`s. You can always consider a `FlagValue` as being a `Flag`.
 
 License: MIT
 
 Copyright © 2019 Upstart Illustration LLC. All rights reserved.
 */

import Foundation

@discardableResult
private func with<T>(_ item: T, update: (inout T) throws -> Void) rethrows -> T {
    var this = item
    try update(&this)
    return this
}

protocol FlagSetter {
    func setValue(_ anyValue: Any)
}

protocol FlagGetter {
    var id: FlagID { get }
    var key: String? { get }
}

typealias FlagValue = FlagGetter & FlagSetter

struct Flag<T>: FlagValue {
    typealias FlagMapper = (Any) -> T?
    
    let id: FlagID // The ID of the FlagValue
    let key: String? // Used to reference a server value for a respective flag
    let `default`: T // The default value of the flag if value is not set
    var value: T? // Value of flag (usually assigned by server)
    let mapper: FlagMapper? // Used to transform server value into flag's respective type
    
    init(id: FlagID, key: String? = nil, `default`: T, value: T? = nil, mapper: FlagMapper? = nil) {
        self.key = key
        self.default = `default`
        self.id = id
        self.value = value
        self.mapper = mapper
    }
    
    func setValue(_ anyValue: Any) {
        if let mapper = mapper {
            with(self) { $0.value = mapper(anyValue) }
        }
        else {
            with(self) { $0.value = anyValue as? T }
        }
    }
}
