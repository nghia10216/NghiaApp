//
//  UIFont+.swift
//  AreaChat
//
//  Created by Napa Mac 006 on 10/01/2023.
//

import Foundation

import Foundation
import UIKit

extension UIFont {
    enum FontWeight: String {
        case bold
        case medium
        case regular

        var openSans: String {
            switch self {
            case .bold:
                return "OpenSans-Bold"
            case .medium:
                return "OpenSans-Medium"
            case .regular:
                return "OpenSans-Regular"
            }
        }
    }
    
    static func getInter(_ weight: FontWeight = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: weight.openSans, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

