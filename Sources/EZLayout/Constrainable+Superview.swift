//
//  UIView+Superview.swift
//
//  Created by Vladyslav Vdovychenko on 25.03.2026.
//

import UIKit

public extension Constrainable {
    
    /// Pins the receiver to its superview's edges with optional exclusions and insets.
    ///
    /// Honors layout direction for leading/trailing and can target the safe area.
    /// - Parameters:
    ///   - excludedEdge: Edges to exclude from pinning.
    ///   - insets: Insets to apply per edge.
    ///   - relation: The relation to use for created constraints.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate created constraints immediately.
    ///   - usingSafeArea: Whether to constrain to the superview's safe area.
    /// - Returns: The created constraints.
    @discardableResult
    func edgesToSuperview(excluding excludedEdge: LayoutEdge = .none,
                          insets: UIEdgeInsets = .zero,
                          relation: NSLayoutConstraint.Relation = .equal,
                          priority: UILayoutPriority = .required,
                          isActive: Bool = true,
                          usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        if !excludedEdge.contains(.top) {
            constraints.append(view.ezl.topToSuperview(offset: insets.top, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea))
        }
        
        if view.effectiveUserInterfaceLayoutDirection == .leftToRight {
            
            if !(excludedEdge.contains(.leading) || excludedEdge.contains(.left)) {
                constraints.append(view.ezl.leftToSuperview(offset: insets.left,
                                                           relation: relation,
                                                           priority: priority,
                                                           isActive: isActive,
                                                           usingSafeArea: usingSafeArea))
            }
            
            if !(excludedEdge.contains(.trailing) || excludedEdge.contains(.right)) {
                constraints.append(view.ezl.rightToSuperview(offset: -insets.right,
                                                            relation: relation,
                                                            priority: priority,
                                                            isActive: isActive,
                                                            usingSafeArea: usingSafeArea))
            }
        } else {
            
            if !(excludedEdge.contains(.leading) || excludedEdge.contains(.right)) {
                constraints.append(view.ezl.rightToSuperview(offset: -insets.right,
                                                            relation: relation,
                                                            priority: priority,
                                                            isActive: isActive,
                                                            usingSafeArea: usingSafeArea))
            }
            
            if !(excludedEdge.contains(.trailing) || excludedEdge.contains(.left)) {
                constraints.append(view.ezl.leftToSuperview(offset: insets.left,
                                                           relation: relation,
                                                           priority: priority,
                                                           isActive: isActive,
                                                           usingSafeArea: usingSafeArea))
            }
        }
        
        if !excludedEdge.contains(.bottom) {
            constraints.append(view.ezl.bottomToSuperview(offset: -insets.bottom,
                                                         relation: relation,
                                                         priority: priority,
                                                         isActive: isActive,
                                                         usingSafeArea: usingSafeArea))
        }
        
        return constraints
    }
    
    /// Constrains the receiver's leading edge relative to its superview.
    ///
    /// Respects right-to-left layout direction and can target the safe area.
    /// - Parameters mirror those of other edge helpers.
    /// - Returns: The created leading constraint.
    @discardableResult
    func leadingToSuperview( _ anchor: NSLayoutXAxisAnchor? = nil,
                             offset: CGFloat = 0,
                             relation: NSLayoutConstraint.Relation = .equal,
                             priority: UILayoutPriority = .required,
                             isActive: Bool = true,
                             usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        
        if view.effectiveUserInterfaceLayoutDirection == .rightToLeft {
            return leading(to: constrainable, anchor, offset: -offset, relation: relation, priority: priority, isActive: isActive)
        } else {
            return leading(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
        }
    }
    
    /// Constrains the receiver's trailing edge relative to its superview.
    ///
    /// Respects right-to-left layout direction and can target the safe area.
    /// - Returns: The created trailing constraint.
    @discardableResult
    func trailingToSuperview( _ anchor: NSLayoutXAxisAnchor? = nil,
                              offset: CGFloat = 0,
                              relation: NSLayoutConstraint.Relation = .equal,
                              priority: UILayoutPriority = .required,
                              isActive: Bool = true,
                              usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        
        if view.effectiveUserInterfaceLayoutDirection == .rightToLeft {
            return trailing(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
        } else {
            return trailing(to: constrainable, anchor, offset: -offset, relation: relation, priority: priority, isActive: isActive)
        }
    }
    
    /// Pins the receiver horizontally to its superview with insets.
    ///
    /// Accounts for layout direction and can target the safe area.
    /// - Returns: The created left/right (or leading/trailing) constraints.
    @discardableResult
    func horizontalToSuperview(insets: UIEdgeInsets = .zero,
                               relation: NSLayoutConstraint.Relation = .equal,
                               priority: UILayoutPriority = .required,
                               isActive: Bool = true,
                               usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        
        if view.effectiveUserInterfaceLayoutDirection == .leftToRight {
            constraints.append(leftToSuperview(offset: insets.left, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea))
            constraints.append(rightToSuperview(offset: -insets.right, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea))
        } else {
            constraints.append(rightToSuperview(offset: -insets.right, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea))
            constraints.append(leftToSuperview(offset: insets.left, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea))
        }
        
        return constraints
    }
    
    /// Pins the receiver vertically to its superview with insets.
    ///
    /// Can target the safe area.
    /// - Returns: The created top and bottom constraints.
    @discardableResult
    func verticalToSuperview(insets: UIEdgeInsets = .zero,
                             relation: NSLayoutConstraint.Relation = .equal,
                             priority: UILayoutPriority = .required,
                             isActive: Bool = true,
                             usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        
        let constraints = [NSLayoutConstraint](arrayLiteral:
            topToSuperview(offset: insets.top, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea),
            bottomToSuperview(offset: -insets.bottom, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
        )
        return constraints
    }
}

/// A bitmask describing which edges to include or exclude when pinning.
public struct LayoutEdge: OptionSet {
    public let rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    /// The top edge.
    public static let top = LayoutEdge(rawValue: 1 << 0)
    /// The bottom edge.
    public static let bottom = LayoutEdge(rawValue: 1 << 1)
    /// The trailing edge (direction-aware).
    public static let trailing = LayoutEdge(rawValue: 1 << 2)
    /// The leading edge (direction-aware).
    public static let leading = LayoutEdge(rawValue: 1 << 3)
    /// The left edge.
    public static let left = LayoutEdge(rawValue: 1 << 4)
    /// The right edge.
    public static let right = LayoutEdge(rawValue: 1 << 5)
    /// No edges.
    public static let none = LayoutEdge(rawValue: 1 << 6)
}

/// Internal helpers and convenience constraints that reference the superview.
public extension Constrainable {
    
    /// Returns the appropriate constrainable for the given superview, optionally using the safe area.
    ///
    /// - Parameters:
    ///   - superview: The superview to target.
    ///   - usingSafeArea: Whether to return the superview's safe area layout guide.
    /// - Returns: The superview or its safe area layout guide.
    /// - Note: Crashes if the view has no superview.
    private func safeConstrainable(for superview: UIView?, usingSafeArea: Bool) -> Layoutable {
        guard let superview = superview else {
            fatalError("Unable to create this constraint to it's superview, because it has no superview.")
        }
        
        prepareForLayout()
        
        if usingSafeArea {
            return superview.safeAreaLayoutGuide
        }
        
        return superview
    }
    
    /// Centers the receiver within its superview.
    ///
    /// - Parameters:
    ///   - offset: Horizontal and vertical offsets from the center.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate created constraints immediately.
    ///   - usingSafeArea: Whether to center relative to the safe area.
    /// - Returns: The created center X and center Y constraints.
    @discardableResult
    func centerInSuperview(offset: CGPoint = .zero,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true,
                           usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return center(in: constrainable, offset: offset, priority: priority, isActive: isActive)
    }
    
    /// Pins the receiver's top-left corner to its superview with insets.
    ///
    /// - Parameters mirror those of `edgesToSuperview`.
    /// - Returns: The created left and top constraints.
    @discardableResult
    func originToSuperview(insets: UIEdgeInsets = .zero,
                           relation: NSLayoutConstraint.Relation = .equal,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true,
                           usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return origin(to: constrainable, insets: insets, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's width relative to its superview.
    ///
    /// - Parameters:
    ///   - dimension: Optional explicit dimension; defaults to the superview's width.
    ///   - multiplier: Multiplier applied to the reference dimension.
    ///   - offset: Constant offset added to the computed value.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    ///   - usingSafeArea: Whether to reference the safe area.
    /// - Returns: The created width constraint.
    @discardableResult
    func widthToSuperview( _ dimension: NSLayoutDimension? = nil,
                           multiplier: CGFloat = 1,
                           offset: CGFloat = 0,
                           relation: NSLayoutConstraint.Relation = .equal,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true,
                           usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return width(to: constrainable, dimension, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's height relative to its superview.
    ///
    /// - Parameters:
    ///   - dimension: Optional explicit dimension; defaults to the superview's width.
    ///   - multiplier: Multiplier applied to the reference dimension.
    ///   - offset: Constant offset added to the computed value.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    ///   - usingSafeArea: Whether to reference the safe area.
    /// - Returns: The created height constraint.
    @discardableResult
    func heightToSuperview( _ dimension: NSLayoutDimension? = nil,
                            multiplier: CGFloat = 1,
                            offset: CGFloat = 0,
                            relation: NSLayoutConstraint.Relation = .equal,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true,
                            usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return height(to: constrainable, dimension, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's left edge to its superview (or a provided X anchor).
    ///
    /// - Returns: The created left constraint.
    @discardableResult
    func leftToSuperview( _ anchor: NSLayoutXAxisAnchor? = nil,
                          offset: CGFloat = 0,
                          relation: NSLayoutConstraint.Relation = .equal,
                          priority: UILayoutPriority = .required,
                          isActive: Bool = true,
                          usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return left(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's right edge to its superview (or a provided X anchor).
    ///
    /// - Returns: The created right constraint.
    @discardableResult
    func rightToSuperview( _ anchor: NSLayoutXAxisAnchor? = nil,
                           offset: CGFloat = 0,
                           relation: NSLayoutConstraint.Relation = .equal,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true,
                           usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return right(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's top edge to its superview (or a provided Y anchor).
    ///
    /// - Returns: The created top constraint.
    @discardableResult
    func topToSuperview( _ anchor: NSLayoutYAxisAnchor? = nil,
                         offset: CGFloat = 0,
                         relation: NSLayoutConstraint.Relation = .equal,
                         priority: UILayoutPriority = .required,
                         isActive: Bool = true,
                         usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return top(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's bottom edge to its superview (or a provided Y anchor).
    ///
    /// - Returns: The created bottom constraint.
    @discardableResult
    func bottomToSuperview( _ anchor: NSLayoutYAxisAnchor? = nil,
                            offset: CGFloat = 0,
                            relation: NSLayoutConstraint.Relation = .equal,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true,
                            usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return bottom(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's horizontal center relative to its superview (or a provided X anchor).
    ///
    /// - Returns: The created center X constraint.
    @discardableResult
    func centerXToSuperview( _ anchor: NSLayoutXAxisAnchor? = nil,
                             multiplier: CGFloat = 1,
                             offset: CGFloat = 0,
                             priority: UILayoutPriority = .required,
                             isActive: Bool = true,
                             usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return centerX(to: constrainable, anchor, multiplier: multiplier, offset: offset, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's vertical center relative to its superview (or a provided Y anchor).
    ///
    /// - Returns: The created center Y constraint.
    @discardableResult
    func centerYToSuperview( _ anchor: NSLayoutYAxisAnchor? = nil,
                             multiplier: CGFloat = 1,
                             offset: CGFloat = 0,
                             priority: UILayoutPriority = .required,
                             isActive: Bool = true,
                             usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: view.superview, usingSafeArea: usingSafeArea)
        return centerY(to: constrainable, anchor, multiplier: multiplier, offset: offset, priority: priority, isActive: isActive)
    }
}
