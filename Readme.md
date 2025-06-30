BuildUniversalFramework
=================
For years I have been evolving a build-script for an external target in an XCode project to build an .xcframework from multiple framework targets (ios, macos, visionos, tvos) which

Todo
------------
`.xcframework`s are typically now most useful for SwiftPackages in order to be integrated into a multi-platform package.
- Generate a `Package.swift` automatically with the correct sha for the built xcframework and make this easy to integrate into a more static `Package.Swift`
- Is it possible to add this submodule to a project to generate a target in an `.xcodeproj` ?
