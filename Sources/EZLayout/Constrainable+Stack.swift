//
//  UIView+Stack.swift
//  Zakaz
//
//  Created by Vladyslav Vdovychenko on 25.03.2026.
//  Copyright © 2026 Zakaz Investments Limited. All rights reserved.
//

import UIKit

public extension Constrainable {
    
    /// Adds the given views as arranged subviews in a lightweight stack and returns created constraints.
    ///
    /// The method pins each view to the container on the cross axis and chains them on the main axis
    /// using the provided spacing. Optionally fixes width and/or height for each added view.
    ///
    /// - Parameters:
    ///   - views: The subviews to add to the receiver in order.
    ///   - axis: The stacking axis. Use `.vertical` to stack top-to-bottom, `.horizontal` for left-to-right.
    ///   - width: Optional fixed width to apply to each subview.
    ///   - height: Optional fixed height to apply to each subview.
    ///   - spacing: The spacing between adjacent subviews along the stacking axis.
    /// - Returns: An array of the created (already activated) `NSLayoutConstraint` instances.
    /// - Important: The receiver's `translatesAutoresizingMaskIntoConstraints` is set to `false`, and each
    ///              added view also has `translatesAutoresizingMaskIntoConstraints` set to `false`.
    @discardableResult
    func stack(_ views: [UIView],
               axis: NSLayoutConstraint.Axis = .vertical,
               width: CGFloat? = nil,
               height: CGFloat? = nil,
               spacing: CGFloat = 0) -> [NSLayoutConstraint] {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var offset: CGFloat = 0
        var previous: UIView?
        var constraints: [NSLayoutConstraint] = []
        
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)

            switch axis {
            case .vertical:
                constraints.append(view.ezl.top(to: previous ?? self.view,
                                               previous?.bottomAnchor ?? self.view.topAnchor, offset: offset))
                constraints.append(view.ezl.leftToSuperview())
                constraints.append(view.ezl.rightToSuperview())
                
                if let lastView = views.last, view == lastView {
                    constraints.append(view.ezl.bottomToSuperview())
                }
            case .horizontal:
                constraints.append(view.ezl.topToSuperview())
                constraints.append(view.ezl.bottomToSuperview())
                constraints.append(view.ezl.left(to: previous ?? self.view,
                                                previous?.rightAnchor ?? self.view.leftAnchor, offset: offset))
                
                if let lastView = views.last, view == lastView {
                    constraints.append(view.ezl.rightToSuperview())
                }
            @unknown default:
                fatalError()
            }
            
            if let width = width {
                constraints.append(view.ezl.width(width))
            }
            
            if let height = height {
                constraints.append(view.ezl.height(height))
            }
            
            offset = spacing
            previous = view
        }
        
        return constraints
    }
}
