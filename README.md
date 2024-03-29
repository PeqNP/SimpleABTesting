# A/B and Feature Flags

Easily configure and retrieve A/B and feature flag configuration.

## Why Does This Exist?

I couldn't find a solution that fit my needs. I needed something that was dead simple to configure and use.

## What Is It For?

I needed a way to continue development on half-baked features while still deploying features or fixes that are complete.

I also needed an easy way to A/B[/C] test using Swift `enum` types rather than primitive types (`Bool`). While the API supports multi-variant values it is built for the most common use-case which is to determine if something is either off or on (`Bool`).

## How It Works

As said before I need to support two different types of flags:

- Feature flags: Flags which prevent features from being visible in a prod/qa/etc environment while the feature is still being worked on
- A/B[/C] flags: Flags that turn certain features on or off to determine fitness of a given feature

In some cases it may be necessary to feature flag A/B flag development work.

### Initialization & Configuration

The flags must first be registered before they can be used.

```swift
// Initialize the flags manager which will return configured values for the production environment.
let flags = Flags(environment: .prod)

// Register the flags
flags.register(flags: [
    Flag<ButtonColor>(id: .buttonColor, key: "button_color", default: .default, available: [.all], mapper: ButtonColor.mapper),
    Flag<Bool>(id: .enableFlyoutMenu, default: false, available: [.dev, .qa])
])
```

In this example we have a multi-variant A/B flag `FlagID.buttonColor` which is of type `ButtonColor`. It is available in `.all` environments. Simply, this means we will be provided with the value of `Flag.value` if it has been set by the server config.

The other flag is a feature flag called `FlagID.enableFlyoutMenu`. It is available only in the development and QA environments. This means that if this flag's configuration value is read in production it will _always_ return the default `Flag.value` of `false`.

### Retrieving Flag Values

The most common use case is to determine if a flag is enabled. This can be done by calling `Flags.isEnabled(for:)`.

```swift
// Get a boolean value (the most common case) for our flag
print("Is the flyout menu enabled? \(flags.isEnabled(for: .enableFlyoutMenu) ? "Yes" : "No").")
// prints: `No`, because we are configured for production and this flag isn't available in production
```

Let's get our multi-variant value. Because the server has not yet configured our flag's value, it will return the default value.

```swift
// Get the multi-variant button color value
var buttonColor = flags.value(for: .buttonColor, ButtonColor.self)
print("The button color is: \(buttonColor.rawValue)")
// prints: `default`, as the server configuration hasn't been set yet!
```

Now let's simulate setting the server config value for `FlagID.buttonColor` and getting the value again.

```swift
// Simulate setting the flag value from the server
flags.setValue(key: "button_color", value: "red")

// Get the multi-variant button color value (again)
buttonColor = flags.value(for: .buttonColor, ButtonColor.self)
print("The button color is: \(buttonColor.rawValue)")
// prints: `red`, as the `Flag.value` has been set by the server!
```

# License

MIT
