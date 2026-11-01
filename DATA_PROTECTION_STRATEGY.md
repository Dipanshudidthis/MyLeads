# Data Protection & Backup Strategy

## The Reality
If a user uninstalls the Leads Import app **without backing up their data**, all leads will be permanently lost.

## Why?
The app stores all data in a **local SQLite database** on the device at:
```
/data/data/com.example.flutter_application_1/databases/leadflow.sqlite
```

When the app is uninstalled, this directory is deleted. No backup = No data.

## How Data Survives Uninstall/Reinstall

### ✅ Method 1: Android Auto Backup (Automatic)
**Status**: Already configured in the app

- Backs up SQLite database to user's Google account
- Restores when app is reinstalled on same device/account
- Configured in `backup_rules.xml` and `data_extraction_rules.xml`

**Time**: Can take up to 24 hours
**Reliability**: Depends on:
  - User having Google account linked
  - User's backup settings enabled (Settings → Google → Manage your Google Account → Backup)
  - Device staying connected to WiFi

**Limitation**: If user signs into a different Google account, backup is not available.

### ✅ Method 2: Manual Export (Guaranteed)
**Status**: Available in Settings → Export

Users can export all data to a JSON file and save it to:
- Google Drive (automatic cloud backup)
- OneDrive
- Dropbox
- Email
- Phone storage

**Time**: Instant
**Reliability**: 100% - User has full control
**Works**: On any device if user imports the backup file

## Data Protection Features in This App

### 1. **First-Launch Notice** (NEW)
On first app launch, users see a dialog explaining:
- Data is stored locally
- Auto Backup provides protection
- Manual export is recommended for safety
- Instructions on how to export

### 2. **Settings Screen Information**
Under Settings → Backup:
- Clear explanation of auto-backup behavior
- Export/Import buttons prominently displayed
- Users informed backup can take up to a day

### 3. **Automatic Backup Rules**
```xml
<!-- backup_rules.xml - Android 11 and below -->
<include domain="root" path="app_flutter/"/>
<include domain="sharedpref" path="."/>
```

```xml
<!-- data_extraction_rules.xml - Android 12+ -->
<cloud-backup>
  <include domain="root" path="app_flutter/"/>
  <include domain="sharedpref" path="."/>
</cloud-backup>
```

## Recommended User Actions

### For Casual Users
1. **Set up Auto Backup** (once)
   - Go to Settings → Google → Manage your Google Account
   - Tap "Backup" tab
   - Ensure "Back up to Google Drive" is ON

2. **Keep app installed** or reinstall on same account
   - Data will restore automatically within 24 hours

### For Power Users / Important Data
1. **Set up Auto Backup** (same as above)

2. **Export quarterly**
   - Open Leads Import → Settings
   - Tap "Export all data"
   - Save file to Google Drive/OneDrive
   - This is your insurance policy

3. **Before Uninstalling**
   - Export data to cloud storage first
   - Then uninstall
   - Then reinstall and import

## What Gets Backed Up

✅ **Backed Up by Auto Backup:**
- SQLite database with all leads, lists, history
- App preferences (theme, country code, etc.)

❌ **NOT Backed Up:**
- Journal files (temporary database files - OK to lose)

## Recovery Process

### If User Lost All Data

**Scenario 1: Auto Backup Available**
1. Uninstall and reinstall app
2. Wait 24 hours
3. Data restores automatically

**Scenario 2: Manual Backup Available**
1. Open Settings → Import
2. Select the backup file (from cloud or device)
3. Data restores instantly

**Scenario 3: No Backup**
- ⚠️ Data is permanently lost
- User can start fresh and reimport from source (CSV, etc.)

## Implementation Details

### First Launch Provider
```dart
// lib/features/settings/providers/first_launch_provider.dart
final firstLaunchProvider = StateNotifierProvider<FirstLaunchNotifier, bool>((ref) {
  return FirstLaunchNotifier();
});
```

Tracks whether user has seen the data protection notice.

### Auto-Triggered Dialog
```dart
// lib/features/home/presentation/home_dashboard_screen.dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (!hasSeenNotice) {
    _showDataProtectionNotice(context, ref);
  }
});
```

Shows on first app launch, never again.

## Best Practices

| Action | Frequency | Why |
|--------|-----------|-----|
| **Enable Auto Backup** | Once | Basic protection |
| **Verify backup is working** | Monthly | Ensure data is being saved |
| **Export to cloud** | Quarterly | Insurance policy |
| **Before major phone changes** | As needed | Safeguard data |

## FAQs

**Q: Will my data survive a factory reset?**
A: Yes, if auto-backup is on. Phone will restore apps and data after setup.

**Q: What if I get a new phone?**
A: Sign into same Google account. Auto backup restores data within 24 hours.

**Q: What if I export data, where is it saved?**
A: User chooses - can save to Downloads, Google Drive, Dropbox, email, etc.

**Q: Can I restore a backup from 6 months ago?**
A: Only if user kept the export file. Auto-backup only keeps latest version.

**Q: Is my data encrypted?**
A: Yes - Android's auto backup uses TLS to Google's servers. Manual backups are encrypted if saved to Google Drive/OneDrive.

**Q: Can Google access my data?**
A: Your data is associated with your Google account. Google could theoretically access it, but that's the tradeoff for backup protection.

## Conclusion

✅ **Data is safe if:**
- User enables Android Auto Backup, OR
- User exports data regularly

❌ **Data is at risk if:**
- Auto Backup is disabled
- User uninstalls without exporting
- User reinstalls on different account

**Recommendation**: Educate users at first launch (DONE ✓) and make export easy (DONE ✓).
