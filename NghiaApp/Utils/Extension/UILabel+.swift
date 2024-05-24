//
//  UILabel+.swift
//
//  Copyright © 2021 KST. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  typealias Highlight = (text: String, isBold: Bool, color: UIColor)
  func highlight(_ highlights: Highlight?...) {
    guard let txtLabel = self.text else { return }
    
    let attributeTxt = NSMutableAttributedString(string: txtLabel)
    
    highlights.enumerated().forEach { index, highlight in
      
      if let text = highlight?.text.lowercased(),
         let isBold = highlight?.isBold,
         let color = highlight?.color {
        let range: NSRange = attributeTxt.mutableString.range(of: text, options: .caseInsensitive)
        
        attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        if isBold {
          attributeTxt.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: self.font.pointSize), range: range)
        }
      }
    }
    
    self.attributedText = attributeTxt
  }
}
