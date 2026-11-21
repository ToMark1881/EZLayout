import XCTest
@testable import EZLayout

#if canImport(UIKit)
import UIKit

private typealias TestView = UIView
#else
import AppKit

/// AppKit puts the origin at the bottom-left by default. Flipping the test views puts it at the top-left, as in
/// UIKit, so one set of expected frames serves both platforms. `testTopStaysOnTopInAnUnflippedView` covers the default.
private final class TestView: NSView {
    override var isFlipped: Bool { true }
}
#endif

private extension EZView {
    func layoutNow() {
        #if canImport(UIKit)
        layoutIfNeeded()
        #else
        layoutSubtreeIfNeeded()
        #endif
    }

    func forceRightToLeft() {
        #if canImport(UIKit)
        semanticContentAttribute = .forceRightToLeft
        #else
        userInterfaceLayoutDirection = .rightToLeft
        #endif
    }
}

final class EZLayoutTests: XCTestCase {

    private var container: EZView!
    private var child: EZView!

    override func setUp() {
        super.setUp()
        container = TestView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        child = TestView()
        container.addSubview(child)
    }

    // MARK: - Superview

    func testEdgesToSuperviewAppliesInsetsAsPositiveValues() {
        child.ezl.edgesToSuperview(insets: .horizontal(16) + .vertical(8))
        container.layoutNow()

        XCTAssertFalse(child.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(child.frame, CGRect(x: 16, y: 8, width: 168, height: 84))
    }

    /// trailing/leading*ToSuperview negate the offset internally, bottom/right ones do not.
    func testSuperviewOffsetSignConvention() {
        child.ezl.leadingToSuperview(offset: 16)
        child.ezl.trailingToSuperview(offset: 16)
        child.ezl.topToSuperview(offset: 8)
        child.ezl.bottomToSuperview(offset: -8)
        container.layoutNow()

        XCTAssertEqual(child.frame, CGRect(x: 16, y: 8, width: 168, height: 84))
    }

    func testCenterInSuperviewWithSize() {
        child.ezl.size(CGSize(width: 50, height: 20))
        child.ezl.centerInSuperview()
        container.layoutNow()

        XCTAssertEqual(child.frame, CGRect(x: 75, y: 40, width: 50, height: 20))
    }

    func testSizeToSuperviewWithMultiplierAndAspectRatio() {
        child.ezl.originToSuperview()
        child.ezl.widthToSuperview(multiplier: 0.5)
        child.ezl.aspectRatio(2)
        container.layoutNow()

        XCTAssertEqual(child.frame, CGRect(x: 0, y: 0, width: 100, height: 50))
    }

    func testUsingSafeAreaTargetsTheSafeAreaGuide() {
        let top = child.ezl.topToSuperview(usingSafeArea: true)
        let plain = child.ezl.bottomToSuperview()

        XCTAssertTrue(top.secondItem === container.safeAreaLayoutGuide)
        XCTAssertTrue(plain.secondItem === container)
    }

    /// With a right-to-left layout the leading edge is the right one: excluding it must leave left, top and bottom.
    func testEdgesToSuperviewExcludesLeadingByLayoutDirection() {
        child.forceRightToLeft()
        let attributes = child.ezl.edgesToSuperview(excluding: .leading).map(\.firstAttribute)

        XCTAssertEqual(attributes.count, 3)
        XCTAssertTrue(attributes.contains(.left))
        XCTAssertFalse(attributes.contains(.right))
    }

    // MARK: - Another view

    func testChainingSiblings() {
        let sibling = TestView()
        container.addSubview(sibling)

        child.ezl.originToSuperview()
        child.ezl.size(CGSize(width: 40, height: 30))
        sibling.ezl.leftToRight(of: child, offset: 10)
        sibling.ezl.topToBottom(of: child, offset: 5)
        sibling.ezl.size(to: child)
        container.layoutNow()

        XCTAssertEqual(sibling.frame, CGRect(x: 50, y: 35, width: 40, height: 30))
    }

    func testLayoutGuideIsLayoutable() {
        let guide = EZLayoutGuide()
        container.addLayoutGuide(guide)
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20),
            guide.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20),
            guide.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            guide.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        child.ezl.edges(to: guide)
        container.layoutNow()

        XCTAssertEqual(child.frame, CGRect(x: 20, y: 10, width: 160, height: 80))
    }

    // MARK: - Constraints

    func testInactiveConstraintAndPriority() {
        let constraint = child.ezl.height(10, priority: .defaultHigh, isActive: false)

        XCTAssertFalse(constraint.isActive)
        XCTAssertEqual(constraint.priority, .defaultHigh)
    }

    func testMinMaxAndActivation() {
        let constraints = child.ezl.width(min: 10, max: 60, isActive: false)
        XCTAssertEqual(constraints.map(\.relation), [.greaterThanOrEqual, .lessThanOrEqual])

        constraints.activate()
        XCTAssertTrue(constraints.allSatisfy(\.isActive))
        constraints.deactivate()
        XCTAssertFalse(constraints.contains(where: \.isActive))
    }

    func testContentPriorities() {
        child.ezl.setHugging(.required, for: .horizontal)
        child.ezl.setCompressionResistance(.defaultLow, for: .vertical)

        XCTAssertEqual(child.contentHuggingPriority(for: .horizontal), .required)
        XCTAssertEqual(child.contentCompressionResistancePriority(for: .vertical), .defaultLow)
    }

    // MARK: - Stack

    func testStackChainsViewsVertically() {
        let first = TestView()
        let second = TestView()

        container.ezl.stack([first, second], height: 20, spacing: 10)

        XCTAssertTrue(first.superview === container)
        XCTAssertTrue(second.superview === container)

        // container height is defined by the stack: 20 + 10 + 20
        let host = TestView(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
        host.addSubview(container)
        container.ezl.edgesToSuperview(excluding: .bottom)
        host.layoutNow()

        XCTAssertEqual(first.frame, CGRect(x: 0, y: 0, width: 200, height: 20))
        XCTAssertEqual(second.frame, CGRect(x: 0, y: 30, width: 200, height: 20))
        XCTAssertEqual(container.frame.height, 50)
    }

    func testStackChainsViewsHorizontally() {
        let first = TestView()
        let second = TestView()

        // container width is defined by the stack: 30 + 10 + 30
        container.ezl.stack([first, second], axis: .horizontal, width: 30, spacing: 10)
        let host = TestView(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
        host.addSubview(container)
        container.ezl.edgesToSuperview(excluding: .right)
        host.layoutNow()

        XCTAssertEqual(first.frame, CGRect(x: 0, y: 0, width: 30, height: 100))
        XCTAssertEqual(second.frame, CGRect(x: 40, y: 0, width: 30, height: 100))
        XCTAssertEqual(container.frame.width, 70)
    }

    // MARK: - Insets

    func testEdgeInsetsHelpers() {
        let insets: EZEdgeInsets = .uniform(4) + .top(2) + .horizontal(10)

        XCTAssertEqual([insets.top, insets.left, insets.bottom, insets.right], [6, 14, 4, 14])
        XCTAssertEqual([EZEdgeInsets.zero.top, EZEdgeInsets.zero.left, EZEdgeInsets.zero.bottom, EZEdgeInsets.zero.right],
                       [0, 0, 0, 0])
    }

    // MARK: - AppKit only

    #if canImport(AppKit) && !canImport(UIKit)

    /// A plain `NSView` counts y from the bottom, but `top` still means the visual top.
    func testTopStaysOnTopInAnUnflippedView() {
        let container = NSView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let child = NSView()
        container.addSubview(child)

        child.ezl.topToSuperview(offset: 8)
        child.ezl.leftToSuperview(offset: 16)
        child.ezl.size(CGSize(width: 50, height: 20))
        container.layoutSubtreeIfNeeded()

        XCTAssertEqual(child.frame, CGRect(x: 16, y: 100 - 8 - 20, width: 50, height: 20))
    }

    /// `usingSafeArea` is honoured on macOS too: the child stays inside the superview's safe area.
    func testSafeAreaInsetsApplyOnMac() {
        container.additionalSafeAreaInsets = NSEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        child.ezl.edgesToSuperview(usingSafeArea: true)
        container.layoutNow()

        XCTAssertEqual(child.frame, CGRect(x: 20, y: 10, width: 140, height: 60))
    }

    /// AppKit controls work as any other view.
    func testAppKitControlInAStackKeepsItsIntrinsicHeight() {
        let label = NSTextField(labelWithString: "EZLayout")
        let button = NSButton(title: "OK", target: nil, action: nil)

        container.ezl.stack([label, button], spacing: 8)
        let host = TestView(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
        host.addSubview(container)
        container.ezl.edgesToSuperview(excluding: .bottom)
        host.layoutNow()

        XCTAssertEqual(label.frame.minY, 0)
        XCTAssertEqual(label.frame.height, label.intrinsicContentSize.height)
        XCTAssertEqual(button.frame.minY, label.frame.maxY + 8)
        XCTAssertEqual(container.frame.height, button.frame.maxY)
    }

    #endif
}
