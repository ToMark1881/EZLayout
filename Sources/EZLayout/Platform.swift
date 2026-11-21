//
//  Platform.swift
//
//  Created by Vladyslav Vdovychenko on 21.11.2026.
//

// The only place where UIKit and AppKit differ for EZLayout. Everything else is written against these names,
// which on iOS are plain aliases of the UIKit types, so existing call sites keep compiling unchanged.
// UIKit is checked first: under Mac Catalyst both frameworks can be imported and UIKit is the one in use.

#if canImport(UIKit)
import UIKit

public typealias EZView = UIView
public typealias EZLayoutGuide = UILayoutGuide
public typealias EZEdgeInsets = UIEdgeInsets
public typealias EZLayoutPriority = UILayoutPriority
public typealias EZAxis = NSLayoutConstraint.Axis

#elseif canImport(AppKit)
import AppKit

public typealias EZView = NSView
public typealias EZLayoutGuide = NSLayoutGuide
public typealias EZEdgeInsets = NSEdgeInsets
public typealias EZLayoutPriority = NSLayoutConstraint.Priority
public typealias EZAxis = NSLayoutConstraint.Orientation

public extension NSEdgeInsets {
    /// Insets of zero on every edge, as `UIEdgeInsets.zero`.
    static var zero: NSEdgeInsets { NSEdgeInsetsZero }
}

extension NSView {
    /// UIKit's name for the direction a view lays out in; AppKit calls it `userInterfaceLayoutDirection`.
    var effectiveUserInterfaceLayoutDirection: NSUserInterfaceLayoutDirection { userInterfaceLayoutDirection }
}

#endif
