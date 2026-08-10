<br/>

<h3 align="center">
  <img src="https://github.com/user-attachments/assets/e459b32a-4d75-4a40-907e-05f5532b6062" alt="Logo" height="150">
</h3>

<h3 align="center">
  🔥 Better Thermal - Unofficial, FOSS App for <a href="https://uni-t-shop.eu/">UNI-T</a> Thermal Cameras 🔥
</h3>

<h6 align="center">
  <a href="https://github.com/simonwep/better-thermal/actions/workflows/analyze.yml"><img src="https://github.com/simonwep/better-thermal/actions/workflows/analyze.yml/badge.svg"/></a>
</h6>

## Why

The [official app](https://play.google.com/store/apps/details?id=com.unitrend.thermal_link&hl=en) is -

- Closed-source
- Partly in Chinese (not translated)
- Slow as heck when browsing photos (on my Pixel 10)
- Asks for too many permissions before it can be used
- Doesn't use all the features the thermal camera actually provides

## Supported devices

> [!NOTE]
> I own a `UTi720E`, the other devices should work as well though as they share the same interface according to their app.
> Supporting more devices is near-impossible, UNI-T implements half a dozen protocols, some custom, some standards across their devices. It's incredible chaotic.
> The devices listed below share the same "API" for browsing files, fetching them and (potentially) live-streaming the video.

Supported thermal cameras are [UTi730E](https://uni-trendus.com/products/uti730e), [UTi720E](https://uni-t-shop.eu/products/uti720e-enhanced-thermal-camera) (tested), [UTi320E](https://www.amazon.com/UNI-T-Infrared-Resolution-Handheld-Detection/dp/B0C8CS92RV), [UTi260E](https://www.amazon.de/UNI-T-Industrial-Professional-Infrared-Electronic/dp/B0BJW7L5KP), and H16T.

## Features

- ✨ Cross-platform, support for Android and Windows (macOS and iOS coming)
- 📺 Live streaming the current image
- 📸 Take and browse photos remotely
- 🔍 Inspect photos taken in detail
- 📤 Export different variants of the photo (raw, visual, thermal, etc.)

## Screenshots

### Live preview and settings

> [!NOTE]
> The recording comes from an emulator, with a physical device I get around 8-15FPS depending on the WI-FI connection.
> All the following images/vides are taken with a [UTi720E](https://uni-t-shop.eu/products/uti720e-enhanced-thermal-camera).

<p float="left">
  <img width="330" alt="Screenshot_20260809_144752" src="https://github.com/user-attachments/assets/ea9a7a24-3f8d-44ee-9e73-46c9c19cfb0d" />
  <img width="330" alt="Screenshot_20260809_144752" src="https://github.com/user-attachments/assets/50d951a4-2fc9-4fc9-8526-580bff82e895" />
  <img width="330" alt="Screenshot_20260809_144645" src="https://github.com/user-attachments/assets/8f2390fd-498b-4aae-9c64-c41fd69a610c" />
</p>

### Inspecting taken images

> [!NOTE]
> Thermal and visual images are both provided by the thermal camera itself.

<p float="left">
  <img width="330" alt="Screenshot_20260809_144621" src="https://github.com/user-attachments/assets/84042e9d-facc-4a32-a18d-9aef7fd6df31" />
  <img width="330" alt="Screenshot_20260810_165605" src="https://github.com/user-attachments/assets/cfdb3e15-9133-45f1-bbb8-945b7e099ff9" />
  <img width="330" alt="Screenshot_20260810_165601" src="https://github.com/user-attachments/assets/ff5adfac-3191-4c8a-a421-9efed602a67b" />
</p>

> [!NOTE]
> Images can be opened to inspect / visualize the raw thermal data (that is also embedded in each image).

<p float="left">
  <img width="330" alt="Screenshot_20260810_165632" src="https://github.com/user-attachments/assets/a8e87abb-9bbe-49f3-9287-75d2e293e639" />
  <img width="330" alt="Screenshot_20260810_165620" src="https://github.com/user-attachments/assets/8536432d-55e5-4e24-9c4e-c8294e25e47b" />
  <img width="330" alt="Screenshot_20260810_165609" src="https://github.com/user-attachments/assets/d45627b2-6d14-4af1-9502-2bb37e2ed6ec" />
</p>


