# Wanderly

A small UIKit demo app (Swift 6, iOS 17+) for exploring travel destinations and saving trips. The UI is fully programmatic: no storyboards, and SF Symbols plus gradients instead of image assets.

## Screens
| View controller | What it shows |
|---|---|
| `DiscoverViewController` | Gradient destination cards (compositional layout + diffable data source) |
| `DestinationDetailViewController` | Hero, info card, "Add to my trips" |
| `TripsViewController` | Saved trips; swipe to remove; tab badge; empty state |
| `ProfileViewController` | Settings toggles, About, Sign out |

## Popups
- **Alert:** confirm adding a trip, clear all trips
- **Action sheet:** share options (Detail), sign out (Profile)
- **Custom card popup** (`CardPopupViewController`): "Surprise me" (✨ on Discover), "Trip saved!", About
- **Bottom sheet** (`FilterSheetViewController`): sort and max-price filter
- **Toast** (`ToastView`): link copied, reminders on/off, signed out
- **System share sheet**

## Project layout
```
Wanderly/
  App/          AppDelegate, SceneDelegate, MainTabBarController
  Models/       Destination, TripStore
  Theme/        Colors, spacing, fonts
  Components/   GradientView, PrimaryButton, DestinationCell, CardPopupViewController, ToastView, EmptyStateView
  Features/     Discover, Detail, Trips, Profile
WanderlyTests/  TripStore, DestinationFilter and view-controller tests
```

## Run
Open `Wanderly.xcodeproj`, choose the **Wanderly** scheme and an iOS simulator, then press ⌘R. Press ⌘U to run the tests.

The project is generated from `project.yml` with [XcodeGen](https://github.com/yonaskolb/XcodeGen). After adding or removing files, run `xcodegen generate`.

From the command line:
```bash
xcodebuild -project Wanderly.xcodeproj -scheme Wanderly -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```
