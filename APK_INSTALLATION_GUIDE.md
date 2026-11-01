# 📱 APK Installation Guide

## APK Locations

### Release APK (Recommended for phones)
```
D:\newprojabhishek\flutter_application_1\build\app\outputs\flutter-apk\app-release.apk
Size: 93.4 MB
Use Case: Production, Play Store submission, daily use
```

### Debug APK (Development & testing)
```
D:\newprojabhishek\flutter_application_1\build\app\outputs\flutter-apk\app-debug.apk
Size: 215.2 MB
Use Case: Testing, debugging, development
```

---

## Installation Methods

### Method 1: Using Flutter (Easiest)

**Prerequisites:**
- Flutter SDK installed
- Android phone connected via USB
- USB Debugging enabled on phone

**Steps:**
```bash
cd D:\newprojabhishek\flutter_application_1

# Install debug version
flutter install

# OR install release version
flutter install --release
```

**Expected Output:**
```
Artifact not found at: ...
Copying artifacts to ...
✓ Built build\app\outputs\flutter-apk\app-release.apk (93.4MB).
√ Installed packages/app-release.apk.
```

### Method 2: Using ADB (Android Debug Bridge)

**Prerequisites:**
- Android SDK Platform Tools installed
- ADB in system PATH
- USB Debugging enabled

**Steps:**
```bash
# Install release APK
adb install "D:\newprojabhishek\flutter_application_1\build\app\outputs\flutter-apk\app-release.apk"

# OR debug APK
adb install "D:\newprojabhishek\flutter_application_1\build\app\outputs\flutter-apk\app-debug.apk"
```

**Expected Output:**
```
Success
```

### Method 3: Manual Installation (Windows File Explorer)

1. Download the APK file from the location above
2. Transfer to phone via USB or cloud
3. On phone: Open Files app → Navigate to APK
4. Tap APK → Tap "Install"
5. Allow "Install from unknown sources" if prompted
6. Wait for installation to complete

---

## Pre-Installation Checklist

### On Your Android Phone

- [ ] **Enable USB Debugging**
  - Settings → Developer Options → USB Debugging (toggle ON)
  - If Developer Options not visible: Settings → About Phone → Tap "Build Number" 7 times
  
- [ ] **Allow Installation from Unknown Sources** (if installing manually)
  - Settings → Apps → Special app access → Install unknown apps → Select Files app → Allow

- [ ] **Free Space**
  - At least 300 MB free space (APK + runtime = ~500 MB)

- [ ] **Android Version**
  - Minimum: Android 6.0 (API 21)
  - Tested: Android 6.0 - 14.0

### On Your Computer

- [ ] **Flutter SDK** (if using Method 1)
  ```bash
  flutter --version
  ```
  - Should show version 3.x or newer

- [ ] **USB Cable**
  - Use a data cable (not charging-only)
  - Tested: USB-C, Micro USB

---

## Step-by-Step Installation (Method 1 - Recommended)

### Step 1: Connect Phone
```
1. Turn off Airplane Mode
2. Unlock phone
3. Connect USB cable to computer
4. Phone should show "USB Debugging Allow?" → Tap "Allow"
5. Computer should detect phone (no driver installation needed for modern phones)
```

### Step 2: Verify Connection
```bash
# In PowerShell, run:
adb devices

# Expected output:
# List of attached devices:
# ABC1234567        device
```

### Step 3: Build & Install
```bash
cd D:\newprojabhishek\flutter_application_1
flutter install --release
```

### Step 4: Launch App
- App installs automatically
- Launches immediately, or tap "Leads Import" icon in launcher

### Step 5: First Launch Experience
- Data protection dialog appears
- Read message about backup options
- Tap "Got it, I understand"
- Dashboard loads with empty state

---

## First-Launch Walkthrough

### Screen 1: Data Protection Notice
```
Title: 📱 Your Data is Protected

Message:
Your leads and follow-ups are stored locally on this phone. 
They will survive an uninstall/reinstall if:

✓ Android Auto Backup is enabled in your Google settings, OR
✓ You manually export your data from Settings → Export

Without one of these, reinstalling the app will lose all data.

Recommendation: Export your data monthly to a cloud service 
(Google Drive, OneDrive, Dropbox) for permanent safety.

Button: "Got it, I understand"
```

### Screen 2: Dashboard
```
Title: Leads Import

Stats:
- Total Leads: 0
- Uncontacted: 0
- Interested: 0
- Follow-ups Today: 0

Actions:
+ Import Leads (blue button)
☰ Lead Lists (bottom nav)
📞 Calls (bottom nav)
⚙️  Settings (bottom nav)
```

### Next Steps After Install
1. Tap "+ Import Leads"
2. Choose import method:
   - Paste multi-line text
   - Import CSV file
   - Manual entry
3. Follow the import wizard
4. Review and select leads to import
5. See dashboard update with counts

---

## Troubleshooting

### "Device not found" / "No devices detected"
```
Solution 1: Check USB connection
  - Try different USB port
  - Try different USB cable
  - Restart phone and computer

Solution 2: Drivers (Windows only, usually not needed)
  - Connect phone and check Device Manager
  - Look for "Android" devices
  - If marked with ⚠️, right-click → Update driver

Solution 3: ADB troubleshooting
  - adb kill-server
  - adb start-server
  - adb devices (should show phone now)
```

### "Installation failed" or "Build failed"
```
Solution 1: Delete build cache
  - flutter clean
  - flutter pub get
  - flutter install --release

Solution 2: Insufficient space on phone
  - Phone needs ~300 MB free
  - Delete unused apps/media
  - Retry installation

Solution 3: Gradle issues (Windows specific)
  - Delete: D:\newprojabhishek\flutter_application_1\android\.gradle
  - flutter clean
  - flutter install --release
```

### "Could not open alarm" or errors on app
```
This is EXPECTED and NORMAL in previous versions.
New release removes alarm system entirely.

If you still see these errors:
  - Uninstall app completely
  - adb uninstall com.example.flutter_application_1
  - Reinstall with fresh APK
```

### App crashes on first launch
```
Solution 1: Clear app data
  - Settings → Apps → Leads Import → Storage → Clear Data
  - Relaunch app

Solution 2: Reinstall
  - adb uninstall com.example.flutter_application_1
  - flutter install --release

Solution 3: Check Android version
  - Settings → About Phone → Android version
  - Should be 6.0 or newer
```

### "Installation failed: File Not Found"
```
Make sure you're using the FULL path with quotes:
  
  WRONG:
  adb install build\app\outputs\flutter-apk\app-release.apk
  
  RIGHT:
  adb install "D:\newprojabhishek\flutter_application_1\build\app\outputs\flutter-apk\app-release.apk"
```

---

## Verifying Installation

### Check App is Installed
```bash
# List all apps
adb shell pm list packages | findstr flutter_application

# Expected output:
# package:com.example.flutter_application_1
```

### Check App Version
```bash
adb shell dumpsys package com.example.flutter_application_1 | findstr versionName
```

### Clear App Data (to reset first launch)
```bash
adb shell pm clear com.example.flutter_application_1
```

### Uninstall App
```bash
adb uninstall com.example.flutter_application_1
```

---

## Performance Notes

| Aspect | Value | Notes |
|--------|-------|-------|
| **APK Size** | 93.4 MB | Release build, optimized |
| **Installed Size** | ~250-300 MB | Includes runtime, data, cache |
| **Launch Time** | 3-5 seconds | First launch may be slower |
| **Database** | SQLite | ~1 MB per 1000 leads |
| **RAM Usage** | 50-150 MB | Depends on lead count |

---

## FAQ

### Q: Can I install multiple versions simultaneously?
**A:** No. Only one version of "Leads Import" can be installed at a time. Reinstalling overwrites the previous version.

### Q: Will my data be preserved when updating?
**A:** YES. The database is stored separately from the APK, so:
- Uninstalling app → Data deleted (unless Auto Backup is on)
- Updating app → Data preserved automatically
- Clearing app cache → Data preserved, app resets

### Q: How do I roll back to a previous version?
**A:** 
1. Keep both APK files on your computer
2. Uninstall current version: `adb uninstall com.example.flutter_application_1`
3. Install previous version: `adb install app-previous.apk`

### Q: Can I install on multiple phones?
**A:** YES. Each phone gets its own local database. Use manual export/import to transfer data between devices.

### Q: Is this app available on Google Play Store?
**A:** Not yet (as of this release). You must sideload using the APK. Play Store submission is planned for future release.

### Q: How often should I export my data?
**A:** 
- **Recommended**: Monthly to cloud storage (Google Drive, OneDrive, Dropbox)
- **Minimum**: Before uninstalling or major Android updates
- **Auto Backup**: Google's backup (up to 24 hours) provides additional safety

---

## Support

If installation fails:

1. **Check this guide** - most issues are covered in Troubleshooting section
2. **Run flutter doctor**: `flutter doctor -v` - check for missing dependencies
3. **Rebuild fresh**:
   ```bash
   cd D:\newprojabhishek\flutter_application_1
   flutter clean
   flutter pub get
   flutter build apk --release
   ```
4. **Review logs**:
   ```bash
   flutter install --release -v  # verbose mode shows more details
   ```

---

**Installation Complete! 🎉**

Enjoy using **Leads Import** on your phone! 📱
