# Simple AB Testing

This project provides a simple interface to get A/B test answers back from a server.

## Goals

- To create a single API call that will return A/B config as a boolean, or multi-variant, value from a remote server which provides A/B testing configuration.
- An API that allows module-specific A/B test configuration (Maybe. Haven't decided if I want to go this far)
- A way to set default values for A/B configuration if the A/B config fails, or takes too long, to be downloaded
- Combines the ability to include feature flags and A/B configuration into a single call. Feature flag takes precedence over A/B config.
- A/B flags can be easily stubbed during test
