//
//  UIEdgeInsets+Extensions.swift
//  Zakaz
//
//  Created by Vladyslav Vdovychenko on 25.03.2026.
//  Copyright © 2026 Zakaz Investments Limited. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {
    
    /// Creates insets with the same value on all edges.
    ///
    /// - Parameter value: The inset to apply to top, left, bottom, and right.
    /// - Returns: A `UIEdgeInsets` with uniform insets.
    static func uniform(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    /// Creates insets applied only to the top edge.
    ///
    /// - Parameter value: The top inset.
    /// - Returns: A `UIEdgeInsets` with a top inset and zeros elsewhere.
    static func top(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }
    
    /// Creates insets applied only to the left edge.
    ///
    /// - Parameter value: The left inset.
    /// - Returns: A `UIEdgeInsets` with a left inset and zeros elsewhere.
    static func left(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }
    
    /// Creates insets applied only to the bottom edge.
    ///
    /// - Parameter value: The bottom inset.
    /// - Returns: A `UIEdgeInsets` with a bottom inset and zeros elsewhere.
    static func bottom(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    /// Creates insets applied only to the right edge.
    ///
    /// - Parameter value: The right inset.
    /// - Returns: A `UIEdgeInsets` with a right inset and zeros elsewhere.
    static func right(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }
    
    /// Creates insets applied to the left and right edges.
    ///
    /// - Parameter value: The inset for both horizontal edges.
    /// - Returns: A `UIEdgeInsets` with left and right insets.
    static func horizontal(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: value, bottom: 0, right: value)
    }
    
    /// Creates insets applied to the top and bottom edges.
    ///
    /// - Parameter value: The inset for both vertical edges.
    /// - Returns: A `UIEdgeInsets` with top and bottom insets.
    static func vertical(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: 0, bottom: value, right: 0)
    }
}

/// Adds two `UIEdgeInsets` values component-wise.
///
/// - Parameters:
///   - lhs: The left-hand insets.
///   - rhs: The right-hand insets.
/// - Returns: A `UIEdgeInsets` whose edges are the sum of the corresponding edges of `lhs` and `rhs`.
public func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    return .init(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
}
