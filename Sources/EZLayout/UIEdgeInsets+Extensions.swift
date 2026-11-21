//
//  UIEdgeInsets+Extensions.swift
//
//  Created by Vladyslav Vdovychenko on 25.03.2026.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension EZEdgeInsets {
    
    /// Creates insets with the same value on all edges.
    ///
    /// - Parameter value: The inset to apply to top, left, bottom, and right.
    /// - Returns: A `EZEdgeInsets` with uniform insets.
    static func uniform(_ value: CGFloat) -> EZEdgeInsets {
        return EZEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    /// Creates insets applied only to the top edge.
    ///
    /// - Parameter value: The top inset.
    /// - Returns: A `EZEdgeInsets` with a top inset and zeros elsewhere.
    static func top(_ value: CGFloat) -> EZEdgeInsets {
        return EZEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }
    
    /// Creates insets applied only to the left edge.
    ///
    /// - Parameter value: The left inset.
    /// - Returns: A `EZEdgeInsets` with a left inset and zeros elsewhere.
    static func left(_ value: CGFloat) -> EZEdgeInsets {
        return EZEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }
    
    /// Creates insets applied only to the bottom edge.
    ///
    /// - Parameter value: The bottom inset.
    /// - Returns: A `EZEdgeInsets` with a bottom inset and zeros elsewhere.
    static func bottom(_ value: CGFloat) -> EZEdgeInsets {
        return EZEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    /// Creates insets applied only to the right edge.
    ///
    /// - Parameter value: The right inset.
    /// - Returns: A `EZEdgeInsets` with a right inset and zeros elsewhere.
    static func right(_ value: CGFloat) -> EZEdgeInsets {
        return EZEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }
    
    /// Creates insets applied to the left and right edges.
    ///
    /// - Parameter value: The inset for both horizontal edges.
    /// - Returns: A `EZEdgeInsets` with left and right insets.
    static func horizontal(_ value: CGFloat) -> EZEdgeInsets {
        return EZEdgeInsets(top: 0, left: value, bottom: 0, right: value)
    }
    
    /// Creates insets applied to the top and bottom edges.
    ///
    /// - Parameter value: The inset for both vertical edges.
    /// - Returns: A `EZEdgeInsets` with top and bottom insets.
    static func vertical(_ value: CGFloat) -> EZEdgeInsets {
        return EZEdgeInsets(top: value, left: 0, bottom: value, right: 0)
    }
}

/// Adds two `EZEdgeInsets` values component-wise.
///
/// - Parameters:
///   - lhs: The left-hand insets.
///   - rhs: The right-hand insets.
/// - Returns: A `EZEdgeInsets` whose edges are the sum of the corresponding edges of `lhs` and `rhs`.
public func + (lhs: EZEdgeInsets, rhs: EZEdgeInsets) -> EZEdgeInsets {
    return .init(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
}
