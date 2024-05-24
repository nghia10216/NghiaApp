//
//  Application+.swift
//
//  Copyright © 2021 KST. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
}
