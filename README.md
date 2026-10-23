# PetPals iPhone SwiftUI project

This is a native iOS SwiftUI prototype styled after the supplied reference screenshots: bright yellow header, compact profile panels, black section bars, pet roster, collections, and a mobile Create-a-Pet screen.

## Build on a Mac
1. Unzip `PetPals-iPhone-Starter.zip`.
2. Open `PetPals.xcodeproj` in Xcode 16 or newer.
3. Select the **PetPals** project, then the **PetPals** target → **Signing & Capabilities**.
4. Choose your Apple Developer Team. If necessary, change `com.example.PetPals` to a unique bundle identifier.
5. Select an iPhone simulator and press Run to test.
6. To export an IPA: select **Any iOS Device (arm64)**, choose **Product → Archive**, then in Organizer choose **Distribute App** and follow the signing/export flow.

## What's implemented
- Dashboard with profile details, HP bar, stats, action icons, pet roster, and collection tiles
- Create-a-pet species grid, four color options, name and gender fields
- Pet collection and profile screens
- Local on-device persistence for pet roster and selected pet
- Original app icon artwork

## Important limitations
The project has not been compiled or signed in this environment. Creating a device-installable IPA requires macOS/Xcode and signing credentials. This version includes cropped artwork taken from the screenshots supplied in this chat. Use only artwork you have permission to use if distributing the app. This independent prototype is not affiliated with Neopets and does not connect to Neopets accounts or services.


## GitHub build and error logs

This repository includes `.github/workflows/ios-build.yml`. GitHub Actions uses a macOS runner and Xcode to compile the app for the iOS Simulator on pushes, pull requests, and manual workflow dispatch.

- The full compiler output is written to `build.log`.
- The `petpals-build-log` artifact is uploaded even when compilation fails.
- A successful build uploads the simulator `.app` separately.
- The workflow does **not** export a signed device IPA. IPA export requires Apple signing credentials and a separate signing/distribution step.

See `BUILD_LOG.txt` for the honest environment check from the packaging session. This Linux environment does not have `xcodebuild`, so no claim is made that the app has compiled successfully here.

## Publish to GitHub

From the unzipped project directory:

```bash
git init
git add .
git commit -m "Add PetPals SwiftUI iOS app"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git push -u origin main
```

Create the repository on GitHub first. Replace the placeholder URL with your repository URL.
