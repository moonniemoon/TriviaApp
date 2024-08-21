//
//  UIButton+Ext.swift
//  TriviaApp
//
//  Created by Selin Kayar on 11.08.24.
//

import UIKit

extension UIButton {
    
    func applyPressStyle(_ theme: PressStyleTheme) {
        setPressStyle(theme) 
        setTitleColor(theme.textColor, for: .normal)
    }
    
}
