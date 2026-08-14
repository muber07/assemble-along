# Assemble Along

An accessible web app for putting together furniture and other products without getting lost in an instruction manual.

## What this prototype demonstrates

- Start from a product photo, retailer link, receipt, or manual
- Identify and confirm the product before building
- Check parts before starting
- Follow a focused, step-by-step assembly flow
- Use a phone level for final alignment

## Run the web app

Open `index.html` in a modern browser. The static web app is responsive, works on phones and desktops, and supports:

- Device camera or photo-library input for product and receipt capture
- Product-link entry and manual uploads
- Product-match confirmation and parts check
- Interactive build guidance
- Browser motion-permission flow for the level tool on supported phones

No build step or server is required for the prototype. Deploy the repository to GitHub Pages, Netlify, or Vercel for a public URL.

## Native iOS starter

1. Install Xcode 15 or newer from the Mac App Store.
2. Open `AssembleAlong.xcodeproj`.
3. Select an iPhone simulator or a connected iPhone.
4. In **Signing & Capabilities**, select your Apple Developer team before running on a device.

The native app currently has real camera/photo-library selection and uses device motion for the level tool. It runs on iOS 17+.

## Contents

- `index.html` — responsive, interactive web app.
- `manifest.webmanifest` — installable-web-app metadata.
- `AssembleAlong.xcodeproj` — native Xcode project.
- `AssembleAlong/AssembleAlongApp.swift` — SwiftUI implementation of the first-version product flow.
- `AssembleAlong/Info.plist` — required camera, photo-library, and motion permission text.
- `AssembleApp.swift` — original standalone SwiftUI reference implementation.

## Native iOS direction

The production app is designed for SwiftUI, with VisionKit for document and receipt capture, AVFoundation for camera input, Vision for barcode/text recognition, RealityKit/ARKit for 3D guidance, Core Motion for the level tool, and SwiftData/CloudKit for saved projects.

The current prototype uses the phone camera/gallery picker for product and receipt photos. Product recognition and manual retrieval will require a backend and approved product-data sources.
