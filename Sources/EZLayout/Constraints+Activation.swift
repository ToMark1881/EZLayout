//
//  UIView+Constraints.swift
//
//  Created by Vladyslav Vdovychenko on 25.03.2026.
//

import UIKit

public extension Collection where Iterator.Element == NSLayoutConstraint {
    
    /// Activates all constraints in the collection.
    ///
    /// Wraps `NSLayoutConstraint.activate(_:)` by conditionally casting the collection to an array.
    /// - Important: Only collections that can be cast to `[NSLayoutConstraint]` will be activated.
    func activate() {
        if let constraints = self as? [NSLayoutConstraint] {
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    /// Deactivates all constraints in the collection.
    ///
    /// Wraps `NSLayoutConstraint.deactivate(_:)` by conditionally casting the collection to an array.
    /// - Important: Only collections that can be cast to `[NSLayoutConstraint]` will be deactivated.
    func deactivate() {
        if let constraints = self as? [NSLayoutConstraint] {
            NSLayoutConstraint.deactivate(constraints)
        }
    }
}

public extension NSLayoutConstraint {
    /// Sets the priority of the constraint and returns the constraint for chaining.
    ///
    /// - Parameter p: The layout priority to assign.
    /// - Returns: The same constraint instance to allow fluent configuration.
    @objc
    func with(_ p: UILayoutPriority) -> Self {
        priority = p
        return self
    }
    
    /// Sets the `isActive` state of the constraint and returns the constraint for chaining.
    ///
    /// - Parameter active: Pass `true` to activate the constraint or `false` to deactivate it.
    /// - Returns: The same constraint instance to allow fluent configuration.
    func set(_ active: Bool) -> Self {
        isActive = active
        return self
    }
}

