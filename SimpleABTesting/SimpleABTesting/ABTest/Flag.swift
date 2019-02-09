/**
 Provides API for a feature flag.
 
 This struct provides a way to identify a server key associated to the A/B or feature flag, a default value when a value isn't set (for a given environment), and closure to map a custom value (an enum rawValue for instance) to its respective type from a value provided by the server.
 
 The `FlagSetter` and `FlagGetter` are ways to get around the generic constraints imposed by Swift when attempting to store a collection of `Flag`s. You can always consider a `FlagValue` as being a `Flag`.
 
 License: MIT
 
 Copyright © 2019 Upstart Illustration LLC. All rights reserved.
 */

import Foundation

protocol FlagSetter {
    func setValue(_ anyValue: Any)
}

protocol FlagGetter {
    var id: FlagID { get }
    var key: String? { get }
}

typealias FlagValue = FlagGetter & FlagSetter

struct DefaultValues<T> {
    let prod: T
    let qa: T
    let dev: T
    
    var asDictionary: [Environment: T] {
        return [
            .prod: prod,
            .qa: qa,
            .dev: dev
        ]
    }
    
    init(prod: T) {
        self.prod = prod
        self.qa = prod
        self.dev = prod
    }
    
    init(prod: T, qa: T) {
        self.prod = prod
        self.qa = qa
        self.dev = qa
    }
    
    init(prod: T, qa: T, dev: T) {
        self.prod = prod
        self.qa = qa
        self.dev = dev
    }
}

class Flag<T>: FlagValue {
    typealias FlagMapper = (Any) -> T?
    
    let id: FlagID // The ID of the FlagValue
    let key: String? // Used to reference a server value for a respective flag
    let defaults: [Environment: T] // The default value of the flag if value is not set
    var value: T? // Value of flag (usually assigned by server)
    let mapper: FlagMapper? // Used to transform server value into flag's respective type
    
    init(id: FlagID, key: String? = nil, `default`: T, value: T? = nil, mapper: FlagMapper? = nil) {
        self.key = key
        self.id = id
        self.value = value
        self.mapper = mapper

        let defaults = DefaultValues(
            prod: `default`,
            qa: `default`,
            dev: `default`
        )
        self.defaults = defaults.asDictionary
    }
    
    init(id: FlagID, key: String? = nil, defaults: DefaultValues<T>, value: T? = nil, mapper: FlagMapper? = nil) {
        self.key = key
        self.id = id
        self.value = value
        self.defaults = defaults.asDictionary
        self.mapper = mapper
    }
    
    func setValue(_ anyValue: Any) {
        // Use custom mapper to transform value from `Any` to respective type
        if let mapper = mapper {
            value = mapper(anyValue)
        }
        // The raw value matches the type of the `Flag`
        else if let castedValue = anyValue as? T {
            value = castedValue
        }
        // The raw value is a string which needs to be converted into the respective `Flag` type
        // Please refer to `FlagValueMaker` for a list of types that have been extended.
        else if let Maker = self.defaults[.prod] as? FlagValueMaker, let stringValue = anyValue as? String, let castedValue = Maker.make(from: stringValue) as? T {
            value = castedValue
        }
    }
}
