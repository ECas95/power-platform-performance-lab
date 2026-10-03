# B005 — StartScreen vs startup navigation logic

## Question
How does declarative initial-screen selection compare with startup logic that determines navigation while other initialization work is running?

## Status
L0 — experiment design.

## Design
Build two otherwise equivalent app variants.

### Variant A — StartScreen
Use `App.StartScreen` to select the initial experience.

### Variant B — startup navigation
Use the legacy/navigation-oriented approach required for the comparison. Document the exact implementation because startup behavior can evolve.

## Metrics

- App launch to initial screen visible.
- App launch to initial screen usable.
- Primary data ready.
- Startup request count.
- Errors and warnings.
- User-visible blocking.

## Evidence rule

Keep Microsoft's documented recommendation separate from this repository's measured result.
