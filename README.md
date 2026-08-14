# Assemble Along

An iPhone-first guide for putting together furniture and other products without getting lost in an instruction manual.

## What this prototype demonstrates

- Start from a product photo, retailer link, receipt, or manual
- Identify and confirm the product before building
- Check parts before starting
- Follow a focused, step-by-step assembly flow
- Use a phone level for final alignment

## Contents

- `index.html` — interactive iPhone-style prototype. Open this file in a browser to try the flow.
- `AssembleApp.swift` — standalone SwiftUI implementation of the same product flow for an Xcode iOS app.

## Native iOS direction

The production app is designed for SwiftUI, with VisionKit for document and receipt capture, AVFoundation for camera input, Vision for barcode/text recognition, RealityKit/ARKit for 3D guidance, Core Motion for the level tool, and SwiftData/CloudKit for saved projects.

The current prototype uses the phone camera/gallery picker for product and receipt photos. Product recognition and manual retrieval will require a backend and approved product-data sources.
