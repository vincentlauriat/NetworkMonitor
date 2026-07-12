# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

NetworkMonitor — a lightweight, open-source macOS network monitor. Rebranded fork of Objective-See's *Netiquette* (originally by Patrick Wardle), GPLv3. Objective-C / Cocoa AppKit app, no Swift. Lists live network connections, listening sockets, and lets the user filter/export them.

## Build

```
xcodebuild -project NetworkMonitor.xcodeproj -scheme NetworkMonitor -configuration Debug build
```

- Only target/scheme: `NetworkMonitor`. Configurations: `Debug`, `Release` (default when `-scheme` is omitted).
- Bundle identifier: `fr.lauriat.networkmonitor`.
- Deployment target: macOS 26.0 (bumped from 10.15 to adopt Liquid Glass — `NSGlassEffectView`/`NSBezelStyleGlass` are macos(26.0)+ only, so this project no longer supports older releases).
- Building requires either removing code-signing (`CODE_SIGNING_ALLOWED=NO`) or supplying your own Apple Developer signing identity — the shipped project referenced Objective-See's own cert before the rebrand.
- There is no Cartfile despite the (now removed) README mention of `carthage update`; no external dependency fetch step is needed to build.
- No test target exists in this project.
- `consts.h`'s `PRODUCT_URL`/`PATREON_URL`/`PRODUCT_VERSIONS_URL` still point at the original Objective-See product page (`.../netiquette.html`) and `products.json` — left untouched during the rebrand since there is no equivalent page for this fork; the in-app update check will simply never find a matching newer version.

## Running

- GUI: launch `NetworkMonitor.app` normally.
- CLI mode: `NetworkMonitor.app/Contents/MacOS/NetworkMonitor -list` scans once and prints connections as JSON (no UI). Flags: `-names` (resolve remote hostnames via DNS), `-pretty` (pretty-print JSON), `-skipApple` (omit Apple-owned processes), `-h`/`-help`.

## Architecture

The app has two entry paths sharing the same monitoring core (`main.m`): a normal `NSApplicationMain` GUI launch, and a synchronous `-list` CLI path that runs one scan via a dispatch semaphore and prints JSON, bypassing the UI entirely.

**Data pipeline**, front to back:

1. **`Monitor`** (`Monitor.h/.m`) wraps Apple's private/undocumented `NetworkStatistics` API (`NStatManager*` functions — no public `NetworkStatistics.h` exists, hence the hand-declared C bindings at the top of `Monitor.h`). It polls TCP/UDP sources on a timer and returns raw per-connection dictionaries via a `NetworkCallbackBlock`.
2. **`Event`** (`Event.h/.m`) wraps one raw connection dict, enriching it with process info looked up via the bundled `procInfo` library (`NetworkMonitor/procInfo/procInfo.h` + prebuilt `libprocInfo.a`, another Objective-See component — not built from source here, linked as a static lib). Produces local/remote address info, byte counters, TCP state, and can self-serialize to JSON and fuzzy-match a search string (`-matches:`).
3. **`sort.m`/`sort.h`** combines raw events by PID into a dictionary of dictionaries, then produces an `OrderedDictionary` (custom class in `3rd-party/OrderedDictionary.h/.m`) sorted by column (name/proto/interface/state) or by traffic volume. `OrderedDictionary` is the data structure the outline view binds to — a dictionary that preserves insertion/sort order, used because `NSOutlineView` needs stable parent(process)/child(connection) ordering.
4. **`TableViewController`** (subclasses `NSOutlineView`) owns both `items` (full set) and `processedItems` (filtered view), diffing/updating the outline view, handling search-box filtering, zoom, and expand/collapse-all state per process group.
5. **`utilities.m`** has cross-cutting helpers: JSON formatting/pretty-printing (`formatResults`, `prettifyJSON` — used by both the CLI path and the UI export), IP address conversion, dark-mode detection, crash-reporter/stderr suppression, and dynamic framework loading.

**Supporting UI controllers** (`AppDelegate`, `PrefsWindowController`, `AboutWindowController`, `UpdateWindowController`) are thin Cocoa window/menu controllers wired via nib/storyboard `IBOutlet`s — no business logic beyond user-facing state (prefs stored in `NSUserDefaults`, keys defined in `consts.h`).

**Update checking** (`Update.h/.m`) hits `PRODUCT_VERSIONS_URL` (objective-see.org/products.json) and reports back to `AppDelegate` via a completion block; this is a custom lightweight version check, not Sparkle.

**Shared constants**: `consts.h` centralizes NSUserDefaults preference keys (`PREFS_*`), dictionary keys used across `Event`/`sort`/`TableViewController` (`PROCESS_PID`, `LOCAL_ADDRESS`, `BYTES_UP`, etc.), and product URLs — check here before introducing a new string key.

## Liquid Glass

The 5 floating action buttons (Save/Preferences/Logo/Expand/Collapse, tags `BUTTON_SAVE`..`BUTTON_COLLAPSE` in `TableViewController.m`) are **not** IBOutlets — they're located at runtime by tag via `self.window.contentView.subviews` in `-[TableViewController applyGlassStyleToFloatingButtons]` (called from `awakeFromNib`), which sets `NSBezelStyleGlass` + an SF Symbol per button. If you add a 6th floating button in the xib, give it a tag and add it to the `symbols` dictionary in that method, or it will render with the system default bezel. The scan overlay (`overlay` IBOutlet) is backed by an `NSGlassEffectView` inserted behind its subviews in the same `awakeFromNib`. `CustomRow`'s selection uses `selectedContentBackgroundColor` (dynamic) rather than manual light/dark branching.

## Documentation page

`docs/index.html` is a self-contained product page (structure loosely modeled on the original Netiquette page at objective-see.org, content/branding own to this fork) — screenshot is embedded as a base64 data URI, not linked externally. Regenerate the screenshot (`docs/images/screenshot.png`, also referenced from `README.md`) after any visible UI change, and re-embed it in `docs/index.html`.

## Localization

`Localizable.xcstrings` / `InfoPlist.xcstrings` (String Catalog format) plus `Base.lproj` and `mul.lproj` — this is a localized app; new user-facing strings should go through the string catalog, not hardcoded literals.
