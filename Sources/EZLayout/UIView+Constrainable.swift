//
//  UIView+Constrainable.swift
//
//  Created by Vladyslav Vdovychenko on 25.03.2026.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol Layoutable {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
}

extension EZView: Layoutable { }
extension EZLayoutGuide: Layoutable { }

public struct Constrainable {
    /// Original view, makes no sense to use during building layout
    public let view: EZView
    
    @discardableResult
    public func prepareForLayout() -> Self {
        view.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

public extension EZView {
    /// Easy (ez) Layout (l)
    var ezl: Constrainable {
        .init(view: self)
    }
}
