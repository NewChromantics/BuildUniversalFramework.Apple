BuildUniversalFramework
=================
For years I have been evolving a build-script for an external target in an XCode project to build an .xcframework from multiple framework targets (ios, macos, visionos, tvos) which

Previous Versions
--------------
These are likely to need updating to the most recent version (which will now live in this project), but may have improvements/bug fixes not included here
- https://github.com/NewChromantics/PopH264/blob/master/Source_Ios/BuildUniversal.sh
- https://github.com/NewChromantics/PopMp4/blob/main/Source_Apple/BuildUniversalFramework.sh
- https://github.com/NewChromantics/PopEngine/blob/master/Source_Ios/BuildUniversal.sh
- https://github.com/NewChromantics/PopMondegreen/blob/main/Source_Apple/BuildUniversal.sh
- https://github.com/NewChromantics/PopCameraDevice/blob/master/Source_Ios/BuildUniversal.sh
- https://github.com/NewChromantics/PopTemplate/blob/main/Source_Ios/BuildUniversal.sh
 
Todo
------------
`.xcframework`s are typically now most useful for SwiftPackages in order to be integrated into a multi-platform package.
- Generate a `Package.swift` automatically with the correct sha for the built xcframework and make this easy to integrate into a more static `Package.Swift`
- Is it possible to add this submodule to a project to generate a target in an `.xcodeproj` ?
- Does this project need a shareable workflow? Just build your target that calls this?
