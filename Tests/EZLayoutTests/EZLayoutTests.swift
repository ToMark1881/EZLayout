import XCTest
import UIKit
@testable import EZLayout

final class EZLayoutTests: XCTestCase {

    private var container: UIView!
    private var child: UIView!

    override func setUp() {
        super.setUp()
        container = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        child = UIView()
        container.addSubview(child)
    }

    func testEdgesToSuperviewAppliesInsetsAsPositiveValues() {
        child.ezl.edgesToSuperview(insets: .horizontal(16) + .vertical(8))
        container.layoutIfNeeded()

        XCTAssertFalse(child.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(child.frame, CGRect(x: 16, y: 8, width: 168, height: 84))
    }

    /// trailing/leading*ToSuperview negate the offset internally, bottom/right ones do not.
    func testSuperviewOffsetSignConvention() {
        child.ezl.leadingToSuperview(offset: 16)
        child.ezl.trailingToSuperview(offset: 16)
        child.ezl.topToSuperview(offset: 8)
        child.ezl.bottomToSuperview(offset: -8)
        container.layoutIfNeeded()

        XCTAssertEqual(child.frame, CGRect(x: 16, y: 8, width: 168, height: 84))
    }

    func testInactiveConstraintAndPriority() {
        let constraint = child.ezl.height(10, priority: .defaultHigh, isActive: false)

        XCTAssertFalse(constraint.isActive)
        XCTAssertEqual(constraint.priority, .defaultHigh)
    }

    func testStackChainsViewsVertically() {
        let first = UIView()
        let second = UIView()

        container.ezl.stack([first, second], height: 20, spacing: 10)

        XCTAssertTrue(first.superview === container)
        XCTAssertTrue(second.superview === container)

        // container height is defined by the stack: 20 + 10 + 20
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
        host.addSubview(container)
        container.ezl.edgesToSuperview(excluding: .bottom)
        host.layoutIfNeeded()

        XCTAssertEqual(first.frame, CGRect(x: 0, y: 0, width: 200, height: 20))
        XCTAssertEqual(second.frame, CGRect(x: 0, y: 30, width: 200, height: 20))
        XCTAssertEqual(container.frame.height, 50)
    }
}
