# Camera and Photo Library Permissions

## Required Permissions

1. **Camera Permission**
   - Key: `NSCameraUsageDescription`
   - Value: `"This app needs access to camera to take photos for your progress tracking."`

2. **Photo Library Permission**
   - Key: `NSPhotoLibraryUsageDescription`
   - Value: `"This app needs access to photo library to import photos for your progress tracking."`


## Testing Permissions

- Camera permission will be requested when you first tap "Take Photo"
- Photo library permission will be requested when you first tap "Import Photo"
- Users can deny permissions, so handle gracefully in your app
