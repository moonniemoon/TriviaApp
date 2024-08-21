//
//  UIView+Ext.swift
//  TriviaApp
//
//  Created by Selin Kayar on 3.08.24.
//

import UIKit
import ObjectiveC

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
    
    // MARK: - Blur effect
    
    func addBlur(style: UIBlurEffect.Style, cornerRadius: CGFloat = 0) {
        removeBlur()
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = cornerRadius
        blurEffectView.clipsToBounds = true
        
        addSubview(blurEffectView)
    }
    
    func removeBlur() {
        subviews.compactMap { $0 as? UIVisualEffectView }.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Tap Gesture Recognizer
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer: UInt8 = 0
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    fileprivate var tapGestureRecognizerAction: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Press Style Animation
    
    var pressStyleView: PressStyleView? {
        subviews.compactMap { $0 as? PressStyleView }.first
    }
    
    private func addPressStyle(pressStyle: PressStyleTheme, action: (() -> Void)? = nil) {
        let pressStyleView = PressStyleView(pressStyle: pressStyle)
        pressStyleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tapGestureRecognizerAction = action

        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTapGesture(_:)))
        tapGesture.minimumPressDuration = 0
        self.addGestureRecognizer(tapGesture)
        
        addSubview(pressStyleView)

        NSLayoutConstraint.activate([
            pressStyleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pressStyleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pressStyleView.topAnchor.constraint(equalTo: topAnchor),
            pressStyleView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layoutIfNeeded()
    }
    
    func setPressStyle(_ pressStyle: PressStyleTheme, action: (() -> Void)? = nil) {
        if let pressStyleView = pressStyleView {
            pressStyleView.pressStyle = pressStyle
        } else {
            addPressStyle(pressStyle: pressStyle, action: action)
        }
    }
    
    @objc func handleLongTapGesture(_ gesture: UILongPressGestureRecognizer) {
        let translationY: CGFloat = pressStyleView?.pressStyle?.hasBorder == true ? 2.7 : 3.5
        
        switch gesture.state {
        case .began:
            self.pressStyleView?.layer.shadowOpacity = 0
            self.transform = CGAffineTransform(translationX: 0, y: translationY)
            
        case .ended, .cancelled, .failed:
            self.tapGestureRecognizerAction?()
            self.pressStyleView?.layer.shadowOpacity = 1
            self.transform = .identity
        default:
            break
        }
    }
    
    func removePressStyle() {
        pressStyleView?.removeFromSuperview()
    }
}
