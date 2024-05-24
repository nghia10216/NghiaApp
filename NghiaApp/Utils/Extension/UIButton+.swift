//
//  UIButtonExtensions.swift
//

import Foundation
import UIKit

extension UIButton {
  
  enum ImageDirection {
    case left, right
  }
  
  func addImage(_ image: UIImage, constant: CGFloat, color: UIColor, position: ImageDirection) {
    let viewSize = self.bounds.height
    // swiftlint:disable identifier_name
    let x = position == .left ? 0 : self.width - (viewSize / 3) * 2
    let view = UIView(frame: CGRect(x: x, y: 0, width: viewSize, height: viewSize))
    let imageView = UIImageView(image: image)
    imageView.tintColor = color
    let iconSize = viewSize/3
    view.addSubview(imageView)
    imageView.frame = CGRect(x: iconSize, y: iconSize, width: iconSize, height: iconSize)
    self.addSubview(view)
  }
}

extension UIButton {
  private func actionHandle(action: Completion? = nil) {
    struct Action {
      static var action: Completion?
    }
    if action != nil {
      Action.action = action
    } else {
      Action.action?()
    }
  }
  
  @objc private func pressed() {
    self.actionHandle()
  }
  
  func addTarget(event: UIControl.Event, handle: @escaping Completion) {
    self.actionHandle(action: handle)
    self.addTarget(self, action: #selector(self.pressed), for: event)
  }
}
