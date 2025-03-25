# TCA-MVP
A highly flexible (But minimal in comparison) implementation of **Point Free**'s **TCA** library

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)
* [Improvements](#improvements)

## General info

This is my take on TCAs library, it's closer to being an interpretation to the REDUX architecture but taking in consideration the full year of content I consumed from **Point Free**'s **TCA** library. The idea behind this is that as a "pseudo library" of sorts it can be modified and edited as much as required instead of depending on someone's else intended requirements or "coding rails".

Once again this isn't nothing against Brandon Williams or Stephen Celis exceptional work of their library but rather a simplification since sometimes it's easier to adopt in a team something you had implemented than something someone else implemented. Also it can be made as simple or refined to a project requirements rather than the absolute complexity TCA set out to tackle.

This repo fails big on the composable aspect but still highly respects as faithful as possible the architecture constraints REDUX has long established. It's a fun project that I had worked on since I've always wanted to have a simplified version of TCA to include in companies' repos, where sometimes overadoption of external libraries can become a detriment to the team.

Even if destined to be used mainly with **SwiftUI** it still uses **UIKit** as it's fairly more comfortable to use **UIKit**'s routing rather than **SwiftUI**'s. I'm well aware **Point Free**'s has resolved routing issues but once again, this is my take of the architecture ands it's intended to use the most minimal amount of external dependencies.

Also, the **UIKit** aspect makes it a bit easier on older projects that have **UIKit** as part of their source code.
    
## Technologies
Xcode 16 was used for development of the application and the iOS Deployment is iOS 18.2 to make the most out of Apple's newest features.

Project is created with:
* REDUX design pattern
* [SwiftLee's](https://www.avanderlee.com/swift/dependency-injection) dependency injection tools.
* SwiftUI
* UIKit
    
## Setup
Paste **SwiftUI Templates** folder into the following directory:
```
/Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates
```

Enjoy some quick "plug and play" templates for this "library".

## Improvements
This repo could be wrapped and turned into an actual library for people to download and access more easily.
