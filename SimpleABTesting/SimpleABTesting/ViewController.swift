/**
 
 Copyright © 2019 Upstart Illustration LLC. All rights reserved.
 */

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the flags manager with the environment the app is running in
        let flags = Flags(environment: .prod)
        
        // Register the flags
        flags.register(flags: [
            Flag<ButtonColor>(id: .buttonColor, key: "button_color", default: .blue, available: .all, mapper: ButtonColor.mapper),
            Flag<Bool>(id: .enableFlyoutMenu, default: false, available: [.dev, .qa])
        ])
        
        // Get a boolean value (the most common case) for our flag
        print("Is the flyout menu enabled? \(flags.isEnabled(for: .enableFlyoutMenu) ? "Yes" : "No").")
        
        // Even if we set `enableFlyoutMenu` to `true` it will be `false` as we're in the `.prod` environment
        flags.setValue(for: .enableFlyoutMenu, value: true)
        print("Is the flyout menu enabled? \(flags.isEnabled(for: .enableFlyoutMenu) ? "Yes" : "No").")

        
        // Get a multi-variant value
        var buttonColor = flags.value(for: .buttonColor, ButtonColor.self)
        print("The button color is: \(buttonColor.rawValue)")
        
        // Update the flag value with the server flag value.
        flags.setValue(key: "button_color", value: "red")
        buttonColor = flags.value(for: .buttonColor, ButtonColor.self)
        print("The button color is: \(buttonColor.rawValue)")
    }
}

