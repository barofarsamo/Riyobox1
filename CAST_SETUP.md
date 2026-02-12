# TV Casting Setup Instructions

This app uses the `cast` package for a pure Dart implementation of the Google Cast protocol, allowing for a custom Flutter device picker. It also includes `flutter_cast_video` for native integration.

## Android Setup

1. **Permissions**: The following permissions are added to `AndroidManifest.xml`:
   - `INTERNET`
   - `ACCESS_NETWORK_STATE`
   - `ACCESS_WIFI_STATE`
   - `CHANGE_WIFI_MULTICAST_STATE`

2. **Cast Options Provider**:
   The `AndroidManifest.xml` includes the `OPTIONS_PROVIDER_CLASS_NAME` meta-data pointing to `com.vrt.flutter_cast_video.CastOptionsProvider`.

3. **Dependencies**:
   `implementation("com.google.android.gms:play-services-cast-framework:21.4.0")` is added to `android/app/build.gradle.kts`.

## iOS Setup (Requirements)

To support casting on iOS, you must add the following to your `Info.plist`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>We use Bluetooth to discover nearby Cast devices.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>We use Bluetooth to discover nearby Cast devices.</string>
<key>NSLocalNetworkUsageDescription</key>
<string>We use the local network to discover and connect to Cast devices on your WiFi.</string>
<key>NSBonjourServices</key>
<array>
  <string>_googlecast._tcp</string>
  <string>_CC1AD845._tcp</string>
</array>
```

## How Casting Works Internally

1. **Discovery**: The app uses mDNS (Multicast DNS) to scan the local network for devices that advertise the `_googlecast._tcp` service.
2. **Connection**: Once a device is selected, the app establishes a socket connection to the TV's IP address on port 8009.
3. **Session**: A virtual session is created. The app sends a `LAUNCH` command to start the Default Media Receiver app on the TV.
4. **Media Loading**: The app sends a `LOAD` message containing the Video URL, content type, and metadata (title, etc.).
5. **Control**: The TV fetches the video from the URL and starts playback. The app can then send commands like `PLAY`, `PAUSE`, `STOP`, or `SEEK`.

## Troubleshooting

- Ensure both the phone and the TV are on the **exact same Wi-Fi network** (and the same band, e.g., both on 2.4GHz or both on 5GHz).
- AP Isolation must be disabled on your router.
- For Android 12+, ensure "Nearby devices" permission is granted.
