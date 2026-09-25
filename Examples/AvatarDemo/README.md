# Avatar Demo

A small UIKit app that uses the Avatar package directly from this checkout.
No login, backend, third-party dependencies, or signing team is needed to run
it in the iOS Simulator.

## Run

1. Clone or download the **whole Avatar repository**, keeping its directory structure.
2. Open `Examples/AvatarDemo/AvatarDemo.xcodeproj` in Xcode 14 or later.
3. Select the shared **AvatarDemo** scheme and an **iPhone or iPad simulator**
   running iOS 15 or later, then press **Run**.

The project references the local Swift package at `../..`; it does not fetch a
second copy from GitHub. Use a simulator runtime supported by your Xcode version.
Running on a physical device requires your own signing team.

## Try it

- **Edit** opens the package's `AvatarEditorViewController`. Done updates the
  preview; Cancel leaves the selected avatar unchanged.
- **Random** creates a new avatar with `Avatar.random()`.
- **Save PNG** opens the Files export picker for the package-rendered PNG,
  without the demo's preview background. It does not request Photos access.
- **Copy ID** copies the complete 32-character hex ID, including leading zeros.
- **Paste ID** reads the clipboard on tap and immediately recreates the avatar.
  You can also type an ID and choose **Load ID** or press Return.

To check the round trip: copy an ID, generate a different avatar, then paste
the saved ID. The original avatar should return. Invalid input shows an error
without changing the selected avatar. Uppercase hex is accepted and normalized;
leading/trailing whitespace is trimmed, while incomplete IDs and `0x` prefixes
are rejected.

The last selected avatar is stored locally in `UserDefaults`. The demo's labels
are available in English and Croatian, following the device language. The
editor uses the package's existing localization behavior.

## Code

- `AvatarDemo/AppDelegate.swift` is the app entry point.
- `AvatarDemo/SceneDelegate.swift` creates the window and root view controller.
- `AvatarDemo/AvatarDemoViewController.swift` demonstrates rendering, editing,
  validation, local persistence, clipboard actions, and PNG export using the
  package's public API.

The layout supports scrolling, iPad widths, light/dark appearance, and Dynamic
Type. No storyboard, service configuration, or generated project tool is needed.
