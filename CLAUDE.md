# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Compound is an iOS/iPadOS SwiftUI app targeting iOS 26.5+, backed by Supabase for database and auth. The project is in early development.

## Build & Test Commands

All commands run from the project root. Substitute `iPhone 16` with any available simulator if needed.

**Build:**
```bash
xcodebuild -project Compound.xcodeproj -scheme Compound -destination 'platform=iOS Simulator,name=iPhone 16' build
```

**Run all tests:**
```bash
xcodebuild test -project Compound.xcodeproj -scheme Compound -destination 'platform=iOS Simulator,name=iPhone 16'
```

**Run unit tests only:**
```bash
xcodebuild test -project Compound.xcodeproj -scheme Compound -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:CompoundTests
```

**Run a single test:**
```bash
xcodebuild test -project Compound.xcodeproj -scheme Compound -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:CompoundTests/CompoundTests/example
```

## Architecture

- **Entry point**: `Compound/CompoundApp.swift` → renders `ContentView`
- **Supabase client**: `Compound/Services/SupabaseClient.swift` — exports a global `supabase: SupabaseClient` singleton used throughout the app
- **Tests**: Use Swift Testing (`@Test`, `#expect`) in `CompoundTests/`; UI tests use XCUITest in `CompoundUITests/`

## Dependencies

- **Supabase** (Swift package) — linked via Swift Package Manager, managed through the Xcode project. No `Package.swift` in the root; add/update dependencies through Xcode's package manager UI.

## Key Conventions

- The Supabase publishable key lives directly in `SupabaseClient.swift` — it is intentionally public (anon key).
- New services should be added under `Compound/Services/`.
- The project uses file-system-synchronized groups in Xcode, so new Swift files added to the `Compound/` folder are automatically picked up without editing `project.pbxproj`.
