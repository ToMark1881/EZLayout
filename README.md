# EZLayout

**EZLayout** (Easy Layout) is a tiny, dependency-free wrapper around UIKit Auto Layout anchors.
It turns verbose anchor code into one readable line per constraint, while still handing you plain
`NSLayoutConstraint` objects.

```swift
// Plain Auto Layout
titleLabel.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
])

// EZLayout
titleLabel.ezl.topToSuperview(offset: 16, usingSafeArea: true)
titleLabel.ezl.horizontalToSuperview(insets: .horizontal(16))
```

- No DSL, no closures, no operator overloading on anchors: every call is a regular method that creates one (or a few) constraints.
- Every call sets `translatesAutoresizingMaskIntoConstraints = false` on the receiver for you.
- Every call activates the constraint by default and returns it, so you can keep a reference and update it later.
- Works with `UIView` and `UILayoutGuide` targets (safe area, keyboard layout guide, custom guides).

## Requirements

| | Minimum |
|---|---|
| iOS | 15.0 |
| Swift tools | 5.9 |
| Xcode | 15.0 |

## Installation

EZLayout is distributed with Swift Package Manager.

### Xcode project

1. **File → Add Package Dependencies…**
2. Paste the repository URL: `https://github.com/ToMark1881/EZLayout.git`
3. Choose a dependency rule (for example *Up to Next Major Version* from `1.0.0`).
4. Add the **EZLayout** library product to every app/framework target that builds layout code.

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/ToMark1881/EZLayout.git", from: "1.0.0")
],
targets: [
    .target(
        name: "MyFeature",
        dependencies: [
            .product(name: "EZLayout", package: "EZLayout")
        ]
    )
]
```

### Local package (monorepo or before you publish)

Keep the package folder next to your project, e.g. `Packages/EZLayout`, then either:

- in Xcode: **File → Add Package Dependencies… → Add Local…**, select the `EZLayout` folder and add the
  **EZLayout** product to your targets, or
- in another package: `.package(path: "../EZLayout")`.

### Import

```swift
import EZLayout
```

Import it in every file that uses `.ezl`, `LayoutEdge`, or the `UIEdgeInsets` helpers.

## Quick start

```swift
import EZLayout
import UIKit

final class ProfileHeaderView: UIView {

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(subtitleLabel)
    }

    private func setupLayout() {
        avatarImageView.ezl.size(CGSize(width: 48, height: 48))
        avatarImageView.ezl.leadingToSuperview(offset: 16)
        avatarImageView.ezl.centerYToSuperview()

        nameLabel.ezl.topToSuperview(offset: 12)
        nameLabel.ezl.leadingToTrailing(of: avatarImageView, offset: 12)
        nameLabel.ezl.trailingToSuperview(offset: 16)

        subtitleLabel.ezl.topToBottom(of: nameLabel, offset: 4)
        subtitleLabel.ezl.leading(to: nameLabel)
        subtitleLabel.ezl.trailingToSuperview(offset: 16)
        subtitleLabel.ezl.bottomToSuperview(offset: -12)
    }
}
```

## Core concepts

### The `ezl` namespace

`view.ezl` returns a lightweight `Constrainable` value wrapping the view. All layout methods live there,
so they never clash with your own `UIView` extensions.

### Defaults

Every constraint method shares the same trailing parameters:

| Parameter | Default | Meaning |
|---|---|---|
| `offset` / `insets` | `0` / `.zero` | Constant of the constraint (see the sign rule below). |
| `relation` | `.equal` | `.lessThanOrEqual` / `.greaterThanOrEqual` for flexible layouts. |
| `priority` | `.required` | Any `UILayoutPriority`. |
| `isActive` | `true` | Pass `false` to create a constraint you will activate later. |
| `usingSafeArea` | `false` | `*ToSuperview` methods only: pin to the superview's `safeAreaLayoutGuide`. |

### ⚠️ Offset sign rule

This is the one thing to memorise. `offset` is passed **as-is** to the underlying constraint, except for
`leadingToSuperview`/`trailingToSuperview` which treat it as an inset.

| Call | Value for a 16 pt gap | Why |
|---|---|---|
| `topToSuperview(offset:)` | `16` | top = superview.top + 16 |
| `leadingToSuperview(offset:)` | `16` | inset |
| `trailingToSuperview(offset:)` | `16` | inset (negated internally) |
| `bottomToSuperview(offset:)` | **`-16`** | bottom = superview.bottom − 16 |
| `rightToSuperview(offset:)` | **`-16`** | right = superview.right − 16 |
| `topToBottom(of:offset:)` | `16` | below the other view |
| `leadingToTrailing(of:offset:)` | `16` | after the other view |
| `bottomToTop(of:offset:)` | **`-16`** | above the other view |
| `trailingToLeading(of:offset:)` | **`-16`** | before the other view |
| `edgesToSuperview(insets:)`, `edges(to:insets:)`, `horizontalToSuperview(insets:)`, `verticalToSuperview(insets:)` | `.uniform(16)` | insets are always positive |

Rule of thumb: **insets are positive; raw offsets towards the bottom/right/trailing side are negative**,
except `trailingToSuperview`.

## API overview

### Superview

| Method | Creates |
|---|---|
| `edgesToSuperview(excluding:insets:…)` | top, left, bottom, right (minus excluded edges) |
| `horizontalToSuperview(insets:…)` / `verticalToSuperview(insets:…)` | left+right / top+bottom |
| `topToSuperview` · `bottomToSuperview` · `leadingToSuperview` · `trailingToSuperview` · `leftToSuperview` · `rightToSuperview` | a single edge (optionally to another anchor of the superview) |
| `centerInSuperview(offset:)` · `centerXToSuperview` · `centerYToSuperview` | centering |
| `widthToSuperview(multiplier:offset:)` · `heightToSuperview(multiplier:offset:)` | dimension relative to superview |
| `originToSuperview(insets:)` | left + top |

All of them accept `usingSafeArea:`.

### Another view or layout guide (`Layoutable`)

| Method | Creates |
|---|---|
| `edges(to:excluding:insets:)` | edges to another view/guide |
| `top(to:)` · `bottom(to:)` · `leading(to:)` · `trailing(to:)` · `left(to:)` · `right(to:)` | same-edge alignment; pass an explicit anchor as the 2nd argument to target a different edge |
| `topToBottom(of:)` · `bottomToTop(of:)` · `leadingToTrailing(of:)` · `trailingToLeading(of:)` · `leftToRight(of:)` · `rightToLeft(of:)` | stacking next to a sibling |
| `center(in:offset:)` · `centerX(to:)` · `centerY(to:)` | centering |
| `width(to:multiplier:offset:)` · `height(to:multiplier:offset:)` | dimension relative to another view |
| `widthToHeight(of:)` · `heightToWidth(of:)` | cross-dimension |
| `size(to:multiplier:insets:)` · `origin(to:insets:)` | both dimensions / top-left corner |

### Size

| Method | Creates |
|---|---|
| `width(_:)` · `height(_:)` | constant dimension |
| `width(min:max:)` · `height(min:max:)` | `≥ min` and/or `≤ max` |
| `size(_ size: CGSize)` | width + height |
| `aspectRatio(_:)` | width = height × ratio |

### Keyboard (iOS 15+)

```swift
// Content follows the keyboard, but never goes below the safe area
stackView.ezl.bottomToKeyboard(of: view, relation: .lessThanOrEqual)
stackView.ezl.bottomToSuperview(priority: .defaultHigh, usingSafeArea: true)
```

`bottomToKeyboard(of:)` uses the owner's `keyboardLayoutGuide` (the superview by default). If the view that
owns the guide sizes itself from its content (self-sizing sheets, `preferredContentSize` containers), pass the
presenting/parent view instead, otherwise the keyboard height feeds back into that size.

### Simple stacking

```swift
container.ezl.stack([firstRow, secondRow, thirdRow], axis: .vertical, height: 44, spacing: 8)
```

Adds the views to the container and chains them. Use `UIStackView` when you need hiding, distribution or
alignment; `stack` is for static lists of equal rows.

### Content priorities

```swift
titleLabel.ezl.setHugging(.required, for: .vertical)
titleLabel.ezl.setCompressionResistance(.required, for: .vertical)
```

### Constraint helpers

```swift
let constraint = view.ezl.height(44, isActive: false)
constraint.with(.defaultHigh).set(true)            // priority + activation, chainable

let constraints = view.ezl.edgesToSuperview(isActive: false)
constraints.activate()                             // also: .deactivate()
```

### `UIEdgeInsets` helpers

```swift
.uniform(16)                     // all edges
.horizontal(16) / .vertical(8)   // left+right / top+bottom
.top(8) / .left(8) / .bottom(8) / .right(8)
.horizontal(16) + .vertical(8)   // insets can be added
```

## Updating constraints

Keep the returned constraint and change its `constant` (or toggle `isActive`) instead of re-creating it:

```swift
private var heightConstraint: NSLayoutConstraint!

func setupLayout() {
    heightConstraint = panelView.ezl.height(0)
}

func expand() {
    heightConstraint.constant = 200
    UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
}
```

`multiplier` is immutable in Auto Layout: deactivate the old constraint before creating a new one.

## Known limitations

- `*ToSuperview` methods and `bottomToKeyboard()` without an owner call `fatalError` when the view has no
  superview. Always call `addSubview` first.
- `edges(to:excluding:)` honours only `.top`, `.left`, `.bottom`, `.right`; `.leading` / `.trailing` are ignored
  there (they work in `edgesToSuperview(excluding:)`).
- `edgesToSuperview` and `horizontalToSuperview` pin physical `left`/`right` edges.
- `leadingToSuperview` / `trailingToSuperview` negate the offset under right-to-left layout. This path has not
  been verified on RTL locales yet; check your layout before shipping an RTL language.
- `LayoutEdge.none` is a distinct flag, not an empty set.

## Best practices

See [Docs/BestPractices.md](Docs/BestPractices.md).

## Running the tests

UIKit tests need an iOS simulator:

```bash
xcodebuild test -scheme EZLayout -destination 'platform=iOS Simulator,name=iPhone 16'
```
