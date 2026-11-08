# EZLayout best practices

Guidelines distilled from production screens, cells and reusable views built with EZLayout.
They are not rules of Auto Layout itself — they are the conventions that keep EZLayout code easy to read,
review and change.

## 1. Structure: build the hierarchy first, then constrain it

Split view code into phases and call them in this order:

| Phase | Contains | Never contains |
|---|---|---|
| `setupAppearance()` / `setupUI()` | colors, fonts, text, corner radius, targets, delegates, hugging/compression | `addSubview`, constraints |
| `setupSubviews()` | `addSubview` / `addArrangedSubview` only | constraints |
| `setupLayout()` | `.ezl` calls only | `addSubview`, styling |

```swift
// UIViewController
override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupSubviews()
    setupLayout()
}

// UIView / UITableViewCell / UICollectionViewCell
private func commonInit() {
    setupAppearance()
    setupSubviews()
    setupLayout()
}
```

Why: every `*ToSuperview` call needs the superview to exist (it `fatalError`s otherwise), and constraints
between siblings need a common ancestor. Building the whole tree first makes the order of constraints irrelevant.

In `setupSubviews()` write the hierarchy top-down so it reads like the screen:

```swift
private func setupSubviews() {
    contentView.addSubview(cardView)

    cardView.addSubview(imageView)
    cardView.addSubview(titleLabel)
    cardView.addSubview(buttonsStackView)

    buttonsStackView.addArrangedSubview(saveButton)
    buttonsStackView.addArrangedSubview(cancelButton)
}
```

## 2. One block per view in `setupLayout()`

Group every constraint of a view together, separate views with a blank line, and order the blocks the way the
eye reads the screen (top → bottom, leading → trailing). Inside a block go: vertical position, horizontal
position, size.

```swift
private func setupLayout() {
    titleLabel.ezl.topToSuperview(offset: 16, usingSafeArea: true)
    titleLabel.ezl.horizontalToSuperview(insets: .horizontal(16))

    subtitleLabel.ezl.topToBottom(of: titleLabel, offset: 4)
    subtitleLabel.ezl.horizontalToSuperview(insets: .horizontal(16))

    confirmButton.ezl.topToBottom(of: subtitleLabel, offset: 24, relation: .greaterThanOrEqual)
    confirmButton.ezl.horizontalToSuperview(insets: .horizontal(16))
    confirmButton.ezl.bottomToSuperview(offset: -16, usingSafeArea: true)
    confirmButton.ezl.height(48)
}
```

For large screens split `setupLayout()` by area (`setupHeaderLayout()`, `setupFooterLayout()`) rather than by
constraint type.

## 3. Get the offset sign right

| Gap of 16 pt | Write |
|---|---|
| `topToSuperview`, `leadingToSuperview`, `trailingToSuperview` | `offset: 16` |
| `bottomToSuperview`, `rightToSuperview` | `offset: -16` |
| `topToBottom(of:)`, `leadingToTrailing(of:)` | `offset: 16` |
| `bottomToTop(of:)`, `trailingToLeading(of:)` | `offset: -16` |
| any `insets:` parameter | positive values |

If a view appears outside its container or overlaps its neighbour by exactly the spacing value, check the sign
first.

## 4. Use the most specific helper

| Instead of | Write |
|---|---|
| four `*ToSuperview` calls | `edgesToSuperview(insets:)` |
| three edges + a different fourth edge | `edgesToSuperview(excluding: .bottom, …)` + the custom edge |
| `leadingToSuperview(offset: 16)` + `trailingToSuperview(offset: 16)` | `horizontalToSuperview(insets: .horizontal(16))` |
| `width(40)` + `height(40)` | `size(CGSize(width: 40, height: 40))` |
| `centerXToSuperview()` + `centerYToSuperview()` | `centerInSuperview()` |
| `UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)` | `.horizontal(16) + .vertical(8)` |
| `view.translatesAutoresizingMaskIntoConstraints = false` | nothing — EZLayout does it |
| raw `anchor.constraint(...)` + `isActive = true` | the matching `.ezl` call |

Mixing raw anchors with EZLayout in one file is a smell: raw anchors flip the sign convention (for example
`guide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16)` lifts the view by 16) and are easy to
misread next to EZLayout calls.

## 5. No magic numbers

Keep spacing values in named constants: a shared spacing scale for grid values (4, 8, 12, 16, 24…) and a
private `Constants` enum for values specific to the view (icon sizes, heights, ratios, priorities).

```swift
private enum Constants {
    static let iconSize = CGSize(width: 24, height: 24)
    static let buttonHeight: CGFloat = 48
    static let yieldingPriority = UILayoutPriority(999)
}
```

## 6. Safe area belongs to screens, not to components

Use `usingSafeArea: true` only on the outermost views of a view controller (headers, bottom bars, full-screen
lists). Reusable views and cells must not know about the safe area — the screen that hosts them decides.

## 7. Self-sizing cells and views

- Pin the content to `contentView` on all four sides so the cell can compute its height.
- Give the bottom edge (or a fixed height) `priority: UILayoutPriority(999)` to avoid conflicts with
  `UIView-Encapsulated-Layout-Height` while the table/collection view resolves the size.
- Multiline labels: `numberOfLines = 0` and, if they must not be squeezed,
  `setCompressionResistance(.required, for: .vertical)`.
- Never add constraints in `prepareForReuse()` or `configure(with:)` — create them once in `init` and only
  change constants / activation afterwards.

## 8. Dynamic layout: keep the constraint, change the constant

```swift
private var bottomConstraint: NSLayoutConstraint!
private var fillWidthConstraint: NSLayoutConstraint!
private var expandedConstraint: NSLayoutConstraint!

private func setupLayout() {
    bottomConstraint = footerView.ezl.bottomToSuperview(offset: -16)
    expandedConstraint = stackView.ezl.width(to: scrollView, isActive: false)
}

func update(hasFooter: Bool, isExpanded: Bool) {
    bottomConstraint.constant = hasFooter ? -16 : 0
    expandedConstraint.isActive = isExpanded
}
```

- Toggle alternatives by creating them with `isActive: false` and switching `isActive`; deactivate the old
  one before activating the new one to avoid transient conflicts.
- A `multiplier` cannot be changed: deactivate the old constraint, then create a new one with `.ezl`.
- Animate with `layoutIfNeeded()` on the common superview inside the animation block.

## 9. `UIStackView` arranged subviews

The stack view owns position: never pin an arranged subview's edges with EZLayout. Only give it a size, and
give that size a priority below `.required` (999) — hidden arranged subviews get a zero-size constraint from the
stack view, and a required height would conflict with it.

```swift
[commentButton, shareButton, deleteButton].forEach {
    $0.ezl.size(CGSize(width: 40, height: 40), priority: UILayoutPriority(999))
}
```

## 10. Flexible content with relations

Center a block but keep it inside the container on small screens:

```swift
placeholderView.ezl.centerInSuperview()
placeholderView.ezl.leadingToSuperview(offset: 16, relation: .greaterThanOrEqual)
placeholderView.ezl.topToSuperview(relation: .greaterThanOrEqual)
placeholderView.ezl.bottomToSuperview(relation: .lessThanOrEqual)
```

Let a label grow up to a limit while keeping a minimum:

```swift
descriptionLabel.ezl.height(min: 18, max: 36)
```

## 11. Keyboard

Follow the keyboard with an inequality, and keep a lower-priority resting position:

```swift
contentView.ezl.bottomToKeyboard(of: view, relation: .lessThanOrEqual)
contentView.ezl.bottomToSuperview(priority: .defaultHigh, usingSafeArea: true)
```

Pass `of:` explicitly when the superview sizes itself from its content (self-sizing sheets), otherwise the
keyboard height feeds back into that size.

## 12. Priorities

- Use named priorities (`.required`, `.defaultHigh`, `.defaultLow`, or a constant such as `yieldingPriority`)
  instead of inline `UILayoutPriority(500)`.
- Only lower a priority to resolve a real conflict, and say why in the constant's name.
- Hugging/compression are part of appearance setup (`setupAppearance()`), not of `setupLayout()`.

## Review checklist

- [ ] Every view is added in `setupSubviews()` before any `.ezl` call.
- [ ] No `translatesAutoresizingMaskIntoConstraints = false` and no raw anchors next to EZLayout code.
- [ ] Each view has a complete set of constraints: X position, Y position, width, height (explicit or intrinsic).
- [ ] Bottom/right/`bottomToTop`/`trailingToLeading` offsets are negative; insets are positive.
- [ ] Safe area used only on the screen's outermost views.
- [ ] No magic numbers; priorities are named.
- [ ] Constraints that change later are stored and updated, not re-created.
- [ ] Arranged subviews of `UIStackView` only get size constraints, with priority 999.
- [ ] No "Unable to simultaneously satisfy constraints" logs when opening the screen, rotating, showing the
      keyboard and switching Dynamic Type sizes.
