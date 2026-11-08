//
//  Layoutable+Constraints.swift
//  Zakaz
//
//  Created by Vladyslav Vdovychenko on 25.03.2026.
//  Copyright © 2026 Zakaz Investments Limited. All rights reserved.
//

import UIKit

public extension Constrainable {
    
    /// Centers the receiver inside another layoutable.
    ///
    /// Creates both `centerX` and `centerY` constraints with optional offsets and returns them.
    /// - Parameters:
    ///   - layoutable: The container to center within.
    ///   - offset: Horizontal (x) and vertical (y) offsets from the exact center.
    ///   - priority: The layout priority to apply to both constraints.
    ///   - isActive: Whether to activate the constraints immediately.
    /// - Returns: The created `centerX` and `centerY` constraints.
    @discardableResult
    func center(in layoutable: Layoutable,
                offset: CGPoint = .zero,
                priority: UILayoutPriority = .required,
                isActive: Bool = true) -> [NSLayoutConstraint] {
        prepareForLayout()
        
        let constraints = [
            centerX(to: layoutable, offset: offset.x, priority: priority, isActive: isActive),
            centerY(to: layoutable, offset: offset.y, priority: priority, isActive: isActive)
        ]
        
        return constraints
    }
    
    /// Pins the receiver's edges to another layoutable, with options to exclude edges.
    ///
    /// Applies insets per edge and supports different relations.
    /// - Parameters:
    ///   - layoutable: The target to pin to.
    ///   - excluding: Edges to exclude from pinning.
    ///   - insets: Insets to apply for each edge.
    ///   - relation: The relation to use for each edge constraint.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraints immediately.
    /// - Returns: An array of created edge constraints.
    @discardableResult
    func edges(to layoutable: Layoutable,
               excluding excludedEdge: LayoutEdge = .none,
               insets: UIEdgeInsets = .zero,
               relation: NSLayoutConstraint.Relation = .equal,
               priority: UILayoutPriority = .required,
               isActive: Bool = true) -> [NSLayoutConstraint] {
        prepareForLayout()
        
        var constraints = [NSLayoutConstraint]()
        
        if !excludedEdge.contains(.top) {
            constraints.append(top(to: layoutable, offset: insets.top, relation: relation, priority: priority, isActive: isActive))
        }
        
        if !excludedEdge.contains(.left) {
            constraints.append(left(to: layoutable, offset: insets.left, relation: relation, priority: priority, isActive: isActive))
        }
        
        if !excludedEdge.contains(.bottom) {
            constraints.append(bottom(to: layoutable, offset: -insets.bottom, relation: relation, priority: priority, isActive: isActive))
        }
        
        if !excludedEdge.contains(.right) {
            constraints.append(right(to: layoutable, offset: -insets.right, relation: relation, priority: priority, isActive: isActive))
        }
        
        return constraints
    }
    
    /// Constrains the receiver to a fixed size.
    ///
    /// - Parameters:
    ///   - size: The width and height constants.
    ///   - relation: The relation to use for both dimensions.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraints immediately.
    /// - Returns: The created width and height constraints.
    @discardableResult
    func size(_ size: CGSize,
              relation: NSLayoutConstraint.Relation = .equal,
              priority: UILayoutPriority = .required,
              isActive: Bool = true) -> [NSLayoutConstraint] {
        prepareForLayout()
        
        let constraints = [
            width(size.width, relation: relation, priority: priority, isActive: isActive),
            height(size.height, relation: relation, priority: priority, isActive: isActive)
        ]
        
        return constraints
    }
    
    /// Matches the receiver's size to another layoutable's size with a multiplier and offsets.
    ///
    /// - Parameters:
    ///   - layoutable: The target whose size is used as a reference.
    ///   - multiplier: Multiplier applied to both width and height.
    ///   - insets: Offsets added to width and height.
    ///   - relation: The relation to use for both constraints.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraints immediately.
    /// - Returns: The created width and height constraints.
    @discardableResult
    func size(to layoutable: Layoutable,
              multiplier: CGFloat = 1,
              insets: CGSize = .zero,
              relation: NSLayoutConstraint.Relation = .equal,
              priority: UILayoutPriority = .required,
              isActive: Bool = true) -> [NSLayoutConstraint] {
        prepareForLayout()
        
        let constraints = [
            width(to: layoutable, multiplier: multiplier, offset: insets.width, relation: relation, priority: priority, isActive: isActive),
            height(to: layoutable, multiplier: multiplier, offset: insets.height, relation: relation, priority: priority, isActive: isActive)
        ]
        
        return constraints
    }
    
    /// Pins the receiver's top-left corner to another layoutable's top-left with insets.
    ///
    /// - Parameters:
    ///   - layoutable: The target to pin to.
    ///   - insets: Insets for left and top edges.
    ///   - relation: The relation to use for the constraints.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraints immediately.
    /// - Returns: The created left and top constraints.
    @discardableResult
    func origin(to layoutable: Layoutable,
                insets: UIEdgeInsets = .zero,
                relation: NSLayoutConstraint.Relation = .equal,
                priority: UILayoutPriority = .required,
                isActive: Bool = true) -> [NSLayoutConstraint] {
        prepareForLayout()
        
        let constraints = [
            left(to: layoutable, offset: insets.left, relation: relation, priority: priority, isActive: isActive),
            top(to: layoutable, offset: insets.top, relation: relation, priority: priority, isActive: isActive)
        ]
        
        return constraints
    }
    
    /// Constrains the receiver's width to a constant value.
    ///
    /// - Parameters:
    ///   - width: The width constant.
    ///   - relation: The relation to use (equal, lessThanOrEqual, greaterThanOrEqual).
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created width constraint.
    @discardableResult
    func width(_ width: CGFloat,
               relation: NSLayoutConstraint.Relation = .equal,
               priority: UILayoutPriority = .required,
               isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.widthAnchor.constraint(equalToConstant: width).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.widthAnchor.constraint(lessThanOrEqualToConstant: width).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.widthAnchor.constraint(greaterThanOrEqualToConstant: width).with(priority).set(isActive)
        @unknown default:
            fatalError()
        }
    }
    
    /// Constrains the receiver's width relative to another layoutable's dimension.
    ///
    /// - Parameters:
    ///   - layoutable: The target providing the reference dimension.
    ///   - dimension: Optional explicit `NSLayoutDimension` to use; defaults to `layoutable.widthAnchor`.
    ///   - multiplier: The multiplier applied to the reference dimension.
    ///   - offset: A constant added to the computed value.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created width constraint.
    @discardableResult
    func width(to layoutable: Layoutable,
               _ dimension: NSLayoutDimension? = nil,
               multiplier: CGFloat = 1,
               offset: CGFloat = 0,
               relation: NSLayoutConstraint.Relation = .equal,
               priority: UILayoutPriority = .required,
               isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.widthAnchor.constraint(equalTo: dimension ?? layoutable.widthAnchor,
                                                   multiplier: multiplier,
                                                   constant: offset).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.widthAnchor.constraint(lessThanOrEqualTo: dimension ?? layoutable.widthAnchor,
                                                             multiplier: multiplier,
                                                             constant: offset).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.widthAnchor.constraint(greaterThanOrEqualTo: dimension ?? layoutable.widthAnchor,
                                                                multiplier: multiplier,
                                                                constant: offset).with(priority).set(isActive)
            
        @unknown default:
            fatalError()
        }
    }

    /// Constrains the receiver's width relative to another layoutable's height.
    ///
    /// Convenience wrapper around `width(to:_:multiplier:offset:relation:priority:isActive:)` using `layoutable.heightAnchor`.
    /// - Parameters:
    ///   - layoutable: The target providing the reference dimension.
    ///   - multiplier: The multiplier applied to the reference dimension.
    ///   - offset: A constant added to the computed value.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created width constraint.
    @discardableResult
    func widthToHeight(of layoutable: Layoutable,
                       multiplier: CGFloat = 1,
                       offset: CGFloat = 0,
                       relation: NSLayoutConstraint.Relation = .equal,
                       priority: UILayoutPriority = .required,
                       isActive: Bool = true) -> NSLayoutConstraint {
        return width(to: layoutable, layoutable.heightAnchor, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Applies optional minimum and/or maximum width constraints.
    ///
    /// - Parameters:
    ///   - min: Optional minimum width.
    ///   - max: Optional maximum width.
    ///   - priority: The layout priority to apply to both constraints.
    ///   - isActive: Whether to activate created constraints immediately.
    /// - Returns: The created constraints (empty if neither bound is provided).
    @discardableResult
    func width(min: CGFloat? = nil,
               max: CGFloat? = nil,
               priority: UILayoutPriority = .required,
               isActive: Bool = true) -> [NSLayoutConstraint] {
        prepareForLayout()
        
        var constraints: [NSLayoutConstraint] = []
        
        if let min = min {
            let constraint = view.widthAnchor.constraint(greaterThanOrEqualToConstant: min).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }
        
        if let max = max {
            let constraint = view.widthAnchor.constraint(lessThanOrEqualToConstant: max).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }
        
        return constraints
    }
    
    /// Constrains the receiver's height to a constant value.
    ///
    /// - Parameters:
    ///   - height: The height constant.
    ///   - relation: The relation to use (equal, lessThanOrEqual, greaterThanOrEqual).
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created height constraint.
    @discardableResult
    func height(_ height: CGFloat,
                relation: NSLayoutConstraint.Relation = .equal,
                priority: UILayoutPriority = .required,
                isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.heightAnchor.constraint(equalToConstant: height).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.heightAnchor.constraint(lessThanOrEqualToConstant: height).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.heightAnchor.constraint(greaterThanOrEqualToConstant: height).with(priority).set(isActive)
        @unknown default:
            fatalError()
        }
    }
    
    /// Constrains the receiver's height relative to another layoutable's dimension.
    ///
    /// - Parameters:
    ///   - layoutable: The target providing the reference dimension.
    ///   - dimension: Optional explicit `NSLayoutDimension` to use; defaults to `layoutable.heightAnchor`.
    ///   - multiplier: The multiplier applied to the reference dimension.
    ///   - offset: A constant added to the computed value.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created height constraint.
    @discardableResult
    func height(to layoutable: Layoutable,
                _ dimension: NSLayoutDimension? = nil,
                multiplier: CGFloat = 1,
                offset: CGFloat = 0,
                relation: NSLayoutConstraint.Relation = .equal,
                priority: UILayoutPriority = .required,
                isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.heightAnchor.constraint(equalTo: dimension ?? layoutable.heightAnchor,
                                                    multiplier: multiplier,
                                                    constant: offset).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.heightAnchor.constraint(lessThanOrEqualTo: dimension ?? layoutable.heightAnchor,
                                                              multiplier: multiplier,
                                                              constant: offset).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.heightAnchor.constraint(greaterThanOrEqualTo: dimension ?? layoutable.heightAnchor,
                                                                 multiplier: multiplier,
                                                                 constant: offset).with(priority).set(isActive)
            
        @unknown default:
            fatalError()
        }
    }

    /// Constrains the receiver's height relative to another layoutable's width.
    ///
    /// Convenience wrapper around `height(to:_:multiplier:offset:relation:priority:isActive:)` using `layoutable.widthAnchor`.
    /// - Parameters:
    ///   - layoutable: The target providing the reference dimension.
    ///   - multiplier: The multiplier applied to the reference dimension.
    ///   - offset: A constant added to the computed value.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created height constraint.
    @discardableResult
    func heightToWidth(of layoutable: Layoutable,
                       multiplier: CGFloat = 1,
                       offset: CGFloat = 0,
                       relation: NSLayoutConstraint.Relation = .equal,
                       priority: UILayoutPriority = .required,
                       isActive: Bool = true) -> NSLayoutConstraint {
        return height(to: layoutable, layoutable.widthAnchor, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Applies optional minimum and/or maximum height constraints.
    ///
    /// - Parameters:
    ///   - min: Optional minimum height.
    ///   - max: Optional maximum height.
    ///   - priority: The layout priority to apply to both constraints.
    ///   - isActive: Whether to activate created constraints immediately.
    /// - Returns: The created constraints (empty if neither bound is provided).
    @discardableResult
    func height(min: CGFloat? = nil,
                max: CGFloat? = nil,
                priority: UILayoutPriority = .required,
                isActive: Bool = true) -> [NSLayoutConstraint] {
        prepareForLayout()
        
        var constraints: [NSLayoutConstraint] = []
        
        if let min = min {
            let constraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: min).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }
        
        if let max = max {
            let constraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: max).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }
        
        return constraints
    }

    /// Constrains the receiver's aspect ratio (width:height).
    ///
    /// - Parameters:
    ///   - ratio: The width-to-height multiplier to maintain.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created aspect ratio constraint.
    @discardableResult
    func aspectRatio(_ ratio: CGFloat,
                     relation: NSLayoutConstraint.Relation = .equal,
                     priority: UILayoutPriority = .required,
                     isActive: Bool = true) -> NSLayoutConstraint {
        return widthToHeight(of: self.view, multiplier: ratio, offset: 0, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Positions the receiver's leading edge relative to another's trailing edge.
    ///
    /// - Parameters:
    ///   - layoutable: The reference whose trailing edge is used.
    ///   - offset: The spacing between trailing and leading edges.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created leading constraint.
    @discardableResult
    func leadingToTrailing(of layoutable: Layoutable,
                           offset: CGFloat = 0,
                           relation: NSLayoutConstraint.Relation = .equal,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        return leading(to: layoutable, layoutable.trailingAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's leading edge to another leading edge (or a provided X anchor).
    ///
    /// - Parameters:
    ///   - layoutable: The reference layoutable.
    ///   - anchor: Optional explicit X anchor to target; defaults to `layoutable.leadingAnchor`.
    ///   - offset: The constant offset to apply.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created constraint.
    @discardableResult
    func leading(to layoutable: Layoutable,
                 _ anchor: NSLayoutXAxisAnchor? = nil,
                 offset: CGFloat = 0,
                 relation: NSLayoutConstraint.Relation = .equal,
                 priority: UILayoutPriority = .required,
                 isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.leadingAnchor.constraint(equalTo: anchor ?? layoutable.leadingAnchor,
                                                          constant: offset).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.leadingAnchor.constraint(lessThanOrEqualTo: anchor ?? layoutable.leadingAnchor,
                                                                    constant: offset).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor ?? layoutable.leadingAnchor,
                                                                       constant: offset).with(priority).set(isActive)
        @unknown default:
            fatalError()
        }
    }
    
    /// Positions the receiver's left edge relative to another's right edge.
    ///
    /// - Parameters:
    ///   - layoutable: The reference whose trailing edge is used.
    ///   - offset: The spacing between trailing and leading edges.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created left constraint.
    @discardableResult
    func leftToRight(of layoutable: Layoutable,
                     offset: CGFloat = 0,
                     relation: NSLayoutConstraint.Relation = .equal,
                     priority: UILayoutPriority = .required,
                     isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        return left(to: layoutable, layoutable.rightAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's left edge to another left edge (or a provided X anchor).
    ///
    ///   - layoutable: The reference layoutable.
    ///   - anchor: Optional explicit X anchor to target; defaults to `nil`.
    ///   - offset: The constant offset to apply.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created constraint.
    @discardableResult
    func left(to layoutable: Layoutable,
              _ anchor: NSLayoutXAxisAnchor? = nil,
              offset: CGFloat = 0,
              relation: NSLayoutConstraint.Relation = .equal,
              priority: UILayoutPriority = .required,
              isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.leftAnchor.constraint(equalTo: anchor ?? layoutable.leftAnchor, constant: offset).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.leftAnchor.constraint(lessThanOrEqualTo: anchor ?? layoutable.leftAnchor, constant: offset).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.leftAnchor.constraint(greaterThanOrEqualTo: anchor ?? layoutable.leftAnchor, constant: offset).with(priority).set(isActive)
        @unknown default:
            fatalError()
        }
    }
    
    /// Positions the receiver's trailing edge relative to another's leading edge.
    ///
    /// - Parameters:
    ///   - layoutable: The reference whose trailing edge is used.
    ///   - offset: The spacing between trailing and leading edges.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created trailing constraint.
    @discardableResult
    func trailingToLeading(of layoutable: Layoutable,
                           offset: CGFloat = 0,
                           relation: NSLayoutConstraint.Relation = .equal,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        return trailing(to: layoutable, layoutable.leadingAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's trailing edge to another trailing edge (or a provided X anchor).
    ///
    ///   - layoutable: The reference layoutable.
    ///   - anchor: Optional explicit X anchor to target; defaults to `layoutable.trailingAnchor`.
    ///   - offset: The constant offset to apply.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created constraint.
    @discardableResult
    func trailing(to layoutable: Layoutable,
                  _ anchor: NSLayoutXAxisAnchor? = nil,
                  offset: CGFloat = 0,
                  relation: NSLayoutConstraint.Relation = .equal,
                  priority: UILayoutPriority = .required,
                  isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.trailingAnchor.constraint(equalTo: anchor ?? layoutable.trailingAnchor,
                                                           constant: offset).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.trailingAnchor.constraint(lessThanOrEqualTo: anchor ?? layoutable.trailingAnchor,
                                                                     constant: offset).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor ?? layoutable.trailingAnchor,
                                                                        constant: offset).with(priority).set(isActive)
        @unknown default:
            fatalError()
        }
    }
    
    /// Positions the receiver's right edge relative to another's left edge.
    ///
    /// - Parameters:
    ///   - layoutable: The reference whose trailing edge is used.
    ///   - offset: The spacing between trailing and leading edges.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created right constraint.
    @discardableResult
    func rightToLeft(of layoutable: Layoutable,
                     offset: CGFloat = 0,
                     relation: NSLayoutConstraint.Relation = .equal,
                     priority: UILayoutPriority = .required,
                     isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        return right(to: layoutable, layoutable.leftAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's right edge to another right edge (or a provided X anchor).
    ///
    ///   - layoutable: The reference layoutable.
    ///   - anchor: Optional explicit X anchor to target; defaults to `layoutable.rightAnchor`.
    ///   - offset: The constant offset to apply.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created constraint.
    @discardableResult
    func right(to layoutable: Layoutable,
               _ anchor: NSLayoutXAxisAnchor? = nil,
               offset: CGFloat = 0,
               relation: NSLayoutConstraint.Relation = .equal,
               priority: UILayoutPriority = .required,
               isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.rightAnchor.constraint(equalTo: anchor ?? layoutable.rightAnchor,
                                                        constant: offset).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.rightAnchor.constraint(lessThanOrEqualTo: anchor ?? layoutable.rightAnchor,
                                                                  constant: offset).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.rightAnchor.constraint(greaterThanOrEqualTo: anchor ?? layoutable.rightAnchor,
                                                                     constant: offset).with(priority).set(isActive)
        @unknown default:
            fatalError()
        }
    }
    
    /// Positions the receiver's top edge below another's bottom edge.
    ///
    /// - Parameters:
    ///   - layoutable: The reference whose trailing edge is used.
    ///   - offset: The spacing between trailing and leading edges.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created top constraint.
    @discardableResult
    func topToBottom(of layoutable: Layoutable,
                     offset: CGFloat = 0,
                     relation: NSLayoutConstraint.Relation = .equal,
                     priority: UILayoutPriority = .required,
                     isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        return top(to: layoutable, layoutable.bottomAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's top edge to another top edge (or a provided Y anchor).
    ///
    ///   - layoutable: The reference layoutable.
    ///   - anchor: Optional explicit X anchor to target; defaults to `layoutable.topAnchor`.
    ///   - offset: The constant offset to apply.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created constraint.
    @discardableResult
    func top(to layoutable: Layoutable,
             _ anchor: NSLayoutYAxisAnchor? = nil,
             offset: CGFloat = 0,
             relation: NSLayoutConstraint.Relation = .equal,
             priority: UILayoutPriority = .required,
             isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.topAnchor.constraint(equalTo: anchor ?? layoutable.topAnchor,
                                                      constant: offset).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.topAnchor.constraint(lessThanOrEqualTo: anchor ?? layoutable.topAnchor,
                                                                constant: offset).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.topAnchor.constraint(greaterThanOrEqualTo: anchor ?? layoutable.topAnchor,
                                                                   constant: offset).with(priority).set(isActive)
        @unknown default:
            fatalError()
        }
    }
    
    /// Positions the receiver's bottom edge above another's top edge.
    ///
    /// - Parameters:
    ///   - layoutable: The reference whose trailing edge is used.
    ///   - offset: The spacing between trailing and leading edges.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created bottom constraint.
    @discardableResult
    func bottomToTop(of layoutable: Layoutable,
                     offset: CGFloat = 0,
                     relation: NSLayoutConstraint.Relation = .equal,
                     priority: UILayoutPriority = .required,
                     isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        return bottom(to: layoutable, layoutable.topAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    /// Constrains the receiver's bottom edge to another bottom edge (or a provided Y anchor).
    ///
    ///   - layoutable: The reference layoutable.
    ///   - anchor: Optional explicit X anchor to target; defaults to `layoutable.bottomAnchor`.
    ///   - offset: The constant offset to apply.
    ///   - relation: The relation to use.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created constraint.
    @discardableResult
    func bottom(to layoutable: Layoutable,
                _ anchor: NSLayoutYAxisAnchor? = nil,
                offset: CGFloat = 0,
                relation: NSLayoutConstraint.Relation = .equal,
                priority: UILayoutPriority = .required,
                isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return view.bottomAnchor.constraint(equalTo: anchor ?? layoutable.bottomAnchor,
                                                         constant: offset).with(priority).set(isActive)
            
        case .lessThanOrEqual: return view.bottomAnchor.constraint(lessThanOrEqualTo: anchor ?? layoutable.bottomAnchor,
                                                                   constant: offset).with(priority).set(isActive)
            
        case .greaterThanOrEqual: return view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor ?? layoutable.bottomAnchor,
                                                                      constant: offset).with(priority).set(isActive)
        @unknown default:
            fatalError()
        }
    }
    
    /// Constrains the receiver's horizontal center relative to another center or a provided X anchor.
    ///
    /// Supports a multiplier when targeting an item rather than an anchor.
    /// - Parameters:
    ///   - layoutable: The reference layoutable.
    ///   - anchor: Optional X anchor to use instead of item-to-item centering.
    ///   - multiplier: Multiplier applied when using item-to-item centering.
    ///   - offset: Constant offset from the centered position.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created center X constraint.
    @discardableResult
    func centerX(to layoutable: Layoutable,
                 _ anchor: NSLayoutXAxisAnchor? = nil,
                 multiplier: CGFloat = 1,
                 offset: CGFloat = 0,
                 priority: UILayoutPriority = .required,
                 isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()
        
        let constraint: NSLayoutConstraint

        if let anchor = anchor {
            constraint = view.centerXAnchor.constraint(equalTo: anchor, constant: offset).with(priority)
        } else {
            constraint = NSLayoutConstraint(item: self.view,
                                            attribute: .centerX,
                                            relatedBy: .equal,
                                            toItem: layoutable,
                                            attribute: .centerX,
                                            multiplier: multiplier,
                                            constant: offset).with(priority)
        }

        constraint.isActive = isActive
        return constraint
    }
    
    /// Constrains the receiver's vertical center relative to another center or a provided Y anchor.
    ///
    /// Supports a multiplier when targeting an item rather than an anchor.
    /// - Parameters:
    ///   - layoutable: The reference layoutable.
    ///   - anchor: Optional Y anchor to use instead of item-to-item centering.
    ///   - multiplier: Multiplier applied when using item-to-item centering.
    ///   - offset: Constant offset from the centered position.
    ///   - priority: The layout priority to apply.
    ///   - isActive: Whether to activate the constraint immediately.
    /// - Returns: The created center Y constraint.
    @discardableResult
    func centerY(to layoutable: Layoutable,
                 _ anchor: NSLayoutYAxisAnchor? = nil,
                 multiplier: CGFloat = 1,
                 offset: CGFloat = 0,
                 priority: UILayoutPriority = .required,
                 isActive: Bool = true) -> NSLayoutConstraint {
        prepareForLayout()

        let constraint: NSLayoutConstraint

        if let anchor = anchor {
            constraint = view.centerYAnchor.constraint(equalTo: anchor, constant: offset).with(priority)
        } else {
            constraint = NSLayoutConstraint(item: self.view,
                                            attribute: .centerY,
                                            relatedBy: .equal,
                                            toItem: layoutable,
                                            attribute: .centerY,
                                            multiplier: multiplier,
                                            constant: offset).with(priority)
        }

        constraint.isActive = isActive
        return constraint
    }
}

public extension Constrainable {
    
    /// Sets the content hugging priority for the specified axis.
    ///
    /// - Parameters:
    ///   - priority: The hugging priority to apply.
    ///   - axis: The axis to which the priority applies.
    func setHugging(_ priority: UILayoutPriority,
                    for axis: NSLayoutConstraint.Axis) {
        view.setContentHuggingPriority(priority, for: axis)
    }
    
    /// Sets the content compression resistance priority for the specified axis.
    ///
    /// - Parameters:
    ///   - priority: The compression resistance priority to apply.
    ///   - axis: The axis to which the priority applies.
    func setCompressionResistance(_ priority: UILayoutPriority,
                                  for axis: NSLayoutConstraint.Axis) {
        view.setContentCompressionResistancePriority(priority, for: axis)
    }
}
