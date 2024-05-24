//
//  ImageDefine.swift
//
//  Copyright © 2021 KST. All rights reserved.
//

import Foundation
import UIKit

extension AppDefine {
  enum Image: String {
    var desc: String {
      return rawValue
    }
    
    case empty = "common_empty"
    
    // Icons
    case icMenu = "ic_menu"
    case icSearch = "ic_search"
    case icCart = "ic_cart"
    
    // Logo
    case logoNav = "logo_navigation"
    
    func toImage() -> UIImage? {
      return UIImage(named: self.desc)
    }
  }
}
