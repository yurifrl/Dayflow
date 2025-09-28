# Repository Guidelines

## Project Structure & Module Organization
Dayflow is an Xcode project anchored at `Dayflow/Dayflow.xcodeproj`. App sources live in `Dayflow/Dayflow`, with `App/` bootstrapping SwiftUI scenes, `Core/` handling capture and analysis, `System/` wrapping macOS permissions, `Utilities/` housing shared helpers, and `Views/` for UI composition. Assets and fonts sit under `Assets.xcassets` and `Fonts/`. Tests reside in `Dayflow/DayflowTests` (unit) and `Dayflow/DayflowUITests` (UI). Release collateral and docs live in `docs/`, while automation scripts for notarization and Sparkle live in `scripts/`.

## Build, Test, and Development Commands
Run `xcodebuild -scheme Dayflow -configuration Debug build` from the repo root to compile the app. Launch the project in Xcode with `open Dayflow/Dayflow.xcodeproj` for iterative SwiftUI previews. Execute unit and UI suites with `xcodebuild test -scheme Dayflow -destination 'platform=macOS' -enableCodeCoverage YES`. For release smoke tests, run `scripts/release.sh` after exporting credentials defined in `scripts/release.env.example`.

## Coding Style & Naming Conventions
Stick to Xcode's Swift defaults: four-space indentation, trailing commas for multi-line literals, and `PascalCase` types with `camelCase` members. Group Swift files by feature within the folders noted above, and prefer extensions to add protocol conformances near their usage. Strings and analytics keys belong in `AnalyticsEventDictionary.md` or dedicated enums to centralize changes. Name assets with lowercase-hyphenated identifiers that match their usage in code.

## Testing Guidelines
Author tests with `XCTestCase` subclasses in `DayflowTests`, using `test_<behavior>()` naming for clarity. UI workflows belong in `DayflowUITests` with explicit wait expectations for asynchronous captures. Maintain coverage for new pipeline logic, and update any stubbed fixtures under the test bundles when API contracts change. Run the `xcodebuild test` command locally before pushing and capture new snapshots if SwiftUI visuals shift.

## Commit & Pull Request Guidelines
Follow the Conventional Commit pattern (`type(scope): short summary`) used in history. Scope names should mirror the folder you touched (e.g., `feat(core):`, `chore(release):`). Each PR should include a concise description, verification steps, and screenshots or GIFs for UI changes. Link related issues, call out configuration updates (Gemini keys, Sparkle feeds), and flag release checklist items when scripts in `scripts/` are involved.

## Release & Configuration Tips
Secrets such as `GEMINI_API_KEY` and Sparkle credentials stay outside the repo—load them via your shell or ignored `.env` files before running release scripts. Verify Sparkle feeds under `docs/` when changing versions, and use `scripts/update_appcast.sh` to refresh metadata after a notarized build. Never commit user-specific capture data; purge local recordings through the in-app Debug panel before sharing builds.
