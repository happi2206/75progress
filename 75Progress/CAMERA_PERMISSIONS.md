# Camera and Photo Library Permissions

To enable camera and photo library access in your app, you need to add the following keys to your Xcode project's Info.plist:

## Required Permissions

1. **Camera Permission**
   - Key: `NSCameraUsageDescription`
   - Value: `"This app needs access to camera to take photos for your progress tracking."`

2. **Photo Library Permission**
   - Key: `NSPhotoLibraryUsageDescription`
   - Value: `"This app needs access to photo library to import photos for your progress tracking."`

## How to Add in Xcode

1. Open your Xcode project
2. Select your project in the navigator
3. Select your target
4. Go to the "Info" tab
5. Add the keys above to the "Custom iOS Target Properties" section

## Alternative: Add via Target Info.plist

If you prefer to edit the Info.plist directly:
1. Find your target's Info.plist file in Xcode
2. Right-click and select "Open As" → "Source Code"
3. Add the permission keys inside the `<dict>` tags

## Testing Permissions

- Camera permission will be requested when you first tap "Take Photo"
- Photo library permission will be requested when you first tap "Import Photo"
- Users can deny permissions, so handle gracefully in your app
