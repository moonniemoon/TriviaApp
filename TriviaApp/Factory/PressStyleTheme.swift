//
//  PressStyleTheme.swift
//  TriviaApp
//
//  Created by Selin Kayar on 6.08.24.
//

import UIKit
 
struct PressStyleTheme {
    let backgroundColor: UIColor
    let textColor: UIColor
    let shadowColor: UIColor
    let hasBorder: Bool
    let borderColor: UIColor?
}

class PressStyleThemeFactory {
    
    var lightBlue: PressStyleTheme {
        PressStyleTheme(
            backgroundColor: Colors.lightBlue,
            textColor: Colors.ultraDarkBlue,
            shadowColor: Colors.regularBlue,
            hasBorder: true,
            borderColor: Colors.darkBlue
        )
    }
    
    var outlined: PressStyleTheme {
        PressStyleTheme(
            backgroundColor: .white,
            textColor: Colors.regularGray,
            shadowColor: Colors.regularGray,
            hasBorder: true,
            borderColor: Colors.regularGray
        )
    }
    
    var outlinedDark: PressStyleTheme {
        PressStyleTheme(
            backgroundColor: .white,
            textColor: Colors.labelLight,
            shadowColor: Colors.labelLight,
            hasBorder: true,
            borderColor: Colors.labelLight
        )
    }
    
    var green: PressStyleTheme {
        PressStyleTheme(
            backgroundColor: Colors.lightGreen,
            textColor: .white,
            shadowColor: Colors.regularGreen,
            hasBorder: true,
            borderColor: Colors.regularGreen
        )
    }
    
    var purple: PressStyleTheme {
        PressStyleTheme(
            backgroundColor: Colors.regularPurple,
            textColor: .white,
            shadowColor: Colors.darkPurple,
            hasBorder: false,
            borderColor: nil
        )
    }
}
