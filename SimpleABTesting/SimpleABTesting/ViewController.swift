/**
 
 Copyright © 2019 Upstart Illustration LLC. All rights reserved.
 */

import UIKit

class ViewController: UIViewController {

    // This could be injected via an assembly
    let flags = Flags()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This could live in the assembly.
        flags.register(flags: [
            Flag<ButtonColor>(id: .buttonColor, key: "button_color", default: .default, mapper: ButtonColor.mapper),
            Flag<Bool>(id: .enableFlyoutMenu, default: false)
        ])
        
        // Get a multi-variant value
        var buttonColor = flags.value(for: .buttonColor, ButtonColor.self)
        print("The button color is: \(buttonColor.rawValue)")
        
        // Get a boolean value (the most common case) for our flag
        if flags.isEnabled(for: .enableFlyoutMenu) {
            print("The flyout menu feature is enabled")
        }
        else {
            print("The flyout menu feature is DISABLED")
        }
        
        flags.setValue(key: "button_color", value: "red")
        buttonColor = flags.value(for: .buttonColor, ButtonColor.self)
        print("The button color is: \(buttonColor.rawValue)")
    }
}

