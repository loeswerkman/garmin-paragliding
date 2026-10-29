# Paragliding

A minimal Garmin Connect IQ watch app (Monkey C) for logging paragliding flights.
Built for the Forerunner 965, aiming to also support other modern map-capable Garmin watches (e.g. Forerunner 955, epix Gen 2, fēnix 7X).


## Vision

A simple flight logger with basic data screens utalising what's available through our modern Garmin watches.

### Data screens

Includes the following data screens:

| Screen | Shows |
| ------ | ----- |
| 1 | Vertical speed (m/s) and ground speed (km/h) |
| 2 | Altitude above sea level (m) |
| 3 | 2D map with GPS position and track |
| 4 | Compass |


### User journey

Press **START** to begin recording a flight and **START** again to stop and save it.
**UP/DOWN** switch screens. **BACK** exits the app (disabled while recording).
Flights are saved as *Hang Gliding* activities and sync to Garmin Connect like any other activity.

### Future goals

Stretch goal: adding the ability to view a 3D map summary of the flight afterwards.


## Note on the project's purpose and originality

This is a personal project: a free app built for my own flights, and practice in writing software across platforms and programming languages.
If anyone else finds it useful, they are free to use it or build on top of it for free.

Other paragliding and vario apps already exist in the Connect IQ Store (some free, some paid).
This app is not necessarily better than existing apps or trying to be; it has been created from scratch out of personal interest in the development process and to play around with data and try different setups.

The project code is written from scratch using Garmin's public Connect IQ SDK and its [documentation](https://developer.garmin.com/connect-iq/monkey-c/).


## Project layout

```
manifest.xml                  App id, supported devices, permissions
monkey.jungle                 Build configuration
resources/                    App name and launcher icon
source/ParaglidingApp.mc      Lifecycle, GPS, vertical speed, flight recording
source/ParaglidingDelegate.mc Button handling and screen switching
source/ParaglidingView.mc     Drawing of the data screens
```


## 1. Prepare the development environment

1. Install [Visual Studio Code](https://code.visualstudio.com/)
   > Note on the use of VS Code: Monkey C, the programming language for Garmin apps, is best supported in VS Code because Garmin only maintains a VS Code extension for the language.
2. Download and run the **Connect IQ SDK Manager** from the [Garmin developer site](https://developer.garmin.com/connect-iq/sdk/).
   - Sign in with a Garmin account.
   - Download the latest SDK and set it as active.
   - Under *Devices*, download the devices you want to test on (at least **Forerunner 965**).
3. Install the **Monkey C** extension (by Garmin) in VS Code.
4. In VS Code run **Monkey C: Verify Installation** from the Command Palette (`Cmd+Shift+P`).
5. Generate a developer key (needed to sign every build): **Monkey C: Generate a Developer Key**.
   Store it outside the repository; `*.der` / `*.pem` files are git-ignored and must never be committed.


## 2. Build and run in the simulator

### From VS Code

1. Open this folder in VS Code.
2. Open a `.mc` file, then **Run > Run Without Debugging** (`Ctrl+F5`).
3. Pick a device (e.g. `fr965`). The simulator starts and loads the app.

### From the command line

```sh
# SDK binaries live in the active SDK folder chosen in the SDK Manager
export SDK="$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/<your-sdk-version>/bin"

"$SDK/connectiq" &                                        # start the simulator
"$SDK/monkeyc" -f monkey.jungle -d fr965 -o bin/Paragliding.prg -y /path/to/developer_key.der
"$SDK/monkeydo" bin/Paragliding.prg fr965                 # load the app in the simulator
```

### Testing in the simulator

- **Simulation > Activity Data**: start simulated sensor data to see speed, altitude and heading change.
- **Simulation > FIT Data > Simulate Data** with a recorded FIT file (e.g. a previous flight) replays real GPS/altitude.
- **Simulation > Set Position** sets a GPS fix for the map screen.
- Use the simulated watch buttons (START, UP, DOWN, BACK) to record and switch screens.


## 3. Run on the watch

1. Build for the device: `monkeyc -f monkey.jungle -d fr965 -o bin/Paragliding.prg -y /path/to/developer_key.der`
   (or **Monkey C: Build for Device** in VS Code).
2. Connect the watch by USB and copy `bin/Paragliding.prg` to `GARMIN/APPS/` on the watch
   (on macOS use [OpenMTP](https://openmtp.ganeshrvel.com/) or Android File Transfer).
3. Disconnect; the app appears in the activity/app list.



## Adding devices

Add an `<iq:product id="..."/>` line to [manifest.xml](manifest.xml). Device ids are listed in the SDK Manager.
The map screen requires a device with map support.
