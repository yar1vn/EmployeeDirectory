#  Square Take Home Assignment
## by Yariv Nissim

### Builds Tools and Versions
Xcode 12.4
Swift 5

### Libraries
UIKit
Combine

### Focus Areas
The architecture is a variation of MVVM with unidirectional data flow with Combine.
The Employee Directory object fetches the data and returns a FetchState object that's a twist on Result since I wanted an initial state as well (aka none).
The UI is updated automatically whenever the state changes (kind of like SwiftUI) in a single method `updateUI`. 

Images are cached using a custom URLCache object defined on a custom URLSession.
I decided to prefetch the small images while loading the directory. The images seemed relatively small (~24KB) and they all loaded very quickly even on a cellular connection.
The full size images are currently not fetched at all. If there was a detail view then they would be loaded lazily and cached as well.

I created a custom icon as well and used the new UILaunchScreen key in info.plist.
I left the main Storyboard even though it only  adds a NavigationController. Sometimes less code is better.

### Dependencies
None.

### Device Focus
The app is universal and will work on iPhones and iPad an either orientation.
It also supports dark mode, adaptive text sizes, and localized text.

### Work Time
I spent about 6~7 hours on this project.

### Anything else?
It's been a while since I built a project from scratch. 
Tried including some new frameworks like Combine, DiffableDataSource, List Layout, Cell Registration and Configuration.
