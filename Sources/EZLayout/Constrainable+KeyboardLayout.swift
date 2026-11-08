//
//  Constraints+KeyboardLayout.swift
//  Zakaz
//
//  Created by Vladyslav Vdovychenko on 16.09.2026.
//  Copyright © 2026 Zakaz Investments Limited. All rights reserved.
//

import UIKit

/// Constraints that follow the keyboard via `UIView.keyboardLayoutGuide`.
public extension Constrainable {
    
    /// Returns the keyboard layout guide the receiver should follow.
    ///
    /// The guide belongs to a view, not to the screen, so the owner matters: a view whose own size
    /// depends on its content (a self-sizing modal, a `preferredContentSize` container) must not own
    /// the guide its subviews are pinned to, otherwise the keyboard height feeds back into that size.
    /// In those cases pass the presenting/parent view explicitly.
    /// - Parameter owner: The view whose keyboard guide to use; defaults to the receiver's superview.
    /// - Returns: The owner's keyboard layout guide.
    /// - Note: Crashes if no owner is passed and the view has no superview.
    func keyboardGuide(of owner: UIView? = nil) -> UILayoutGuide {
        guard let owner = owner ?? view.superview else {
            fatalError("Unable to create this constraint to the keyboard, because the view has no superview.")
        }
        
        return owner.keyboardLayoutGuide
    }
    
    /// Positions the receiver's bottom edge above the keyboard.
    ///
    /// While the keyboard is hidden the guide sits on the owner's bottom edge, so the same constraint
    /// also describes the resting layout.
    /// - Parameters:
    ///   - owner: The view whose keyboard guide to follow; defaults to the receiver's superview.
    ///   - offset: The spacing between the receiver's bottom edge and the keyboard's top edge.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created bottom constraint.
    @discardableResult
    func bottomToKeyboard(of owner: UIView? = nil,
                          offset: CGFloat = 0,
                          relation: NSLayoutConstraint.Relation = .equal,
                          priority: UILayoutPriority = .required,
                          isActive: Bool = true) -> NSLayoutConstraint {
        let guide = keyboardGuide(of: owner)
        return bottom(to: guide, guide.topAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
}
