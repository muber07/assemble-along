# Assemble Along

An iPhone-first guide for putting together furniture and other products without getting lost in an instruction manual.

## What this prototype demonstrates

- Start from a product photo, retailer link, receipt, or manual
- Identify and confirm the product before building
- Check parts before starting
- Follow a focused, step-by-step assembly flow
- Use a phone level for final alignment

## Run the native app

1. Install Xcode 15 or newer from the Mac App Store.
2. Open `AssembleAlong.xcodeproj`.
3. Select an iPhone simulator or a connected iPhone.
4. In **Signing & Capabilities**, select your Apple Developer team before running on a device.

The native app currently has real camera/photo-library selection and uses device motion for the level tool. It runs on iOS 17+.

## Contents

- `index.html` — interactive iPhone-style prototype. Open this file in a browser to try the flow.
- `AssembleAlong.xcodeproj` — native Xcode project.
- `AssembleAlong/AssembleAlongApp.swift` — SwiftUI implementation of the first-version product flow.
- `AssembleAlong/Info.plist` — required camera, photo-library, and motion permission text.
- `AssembleApp.swift` — original standalone SwiftUI reference implementation.

## Native iOS direction

The production app is designed for SwiftUI, with VisionKit for document and receipt capture, AVFoundation for camera input, Vision for barcode/text recognition, RealityKit/ARKit for 3D guidance, Core Motion for the level tool, and SwiftData/CloudKit for saved projects.

The current prototype uses the phone camera/gallery picker for product and receipt photos. Product recognition and manual retrieval will require a backend and approved product-data sources.
