/**
 Contains a list of all the IDs for your feature flags and A/B flags.
 
 `FlagID`s are a way to easily reference a value for a given flag using the `Flags` class. This file should be considered volatile as it will change whenever new flags are added, removed, etc.
 
 License: MIT
 
 Copyright © 2019 Upstart Illustration LLC. All rights reserved.
 */

import Foundation

enum FlagID: Equatable {
    case buttonColor
    case enableFlyoutMenu
}
