//
//  UITextFieldExtensions.swift
//

import Foundation
import UIKit

extension UITextField {
  
  @IBInspectable var leftImage: UIImage? {
    get {
      return self.leftImage
    }
    set {
      guard let ic = newValue else { return }
      addImage(ic, color: tintColor, direction: .left)
    }
  }
  
  @IBInspectable var rightImage: UIImage? {
    get {
      return self.rightImage
    }
    set {
      guard let ic = newValue else { return }
      addImage(ic, color: tintColor, direction: .right)
    }
  }
  
  enum Direction {
    case left, right
  }
  
  func addImage(_ image: UIImage, color iconColor: UIColor, direction: Direction) {
    let viewSize = self.bounds.height
    let view = UIView(frame: CGRect(x: 0, y: 0, width: viewSize/2, height: viewSize))
    let imageView = UIImageView(image: image)
    imageView.tintColor = iconColor
    let iconSize = viewSize/3
    view.addSubview(imageView)
    imageView.frame = CGRect(x: iconSize/3, y: iconSize, width: iconSize, height: iconSize)
    
    if direction == .left {
      self.leftViewMode = .always
      self.leftView = view
    } else if direction == .right {
      self.rightViewMode = .always
      self.rightView = view
    }
  }
}

extension UITextField {
  
  @IBInspectable var doneAccessory: Bool {
    get {
      return self.doneAccessory
    }
    set (hasDone) {
      if hasDone {
        addDoneButtonOnKeyboard()
      }
    }
  }
  
  private func addDoneButtonOnKeyboard() {
    let doneToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneAction))
    doneButton.tintColor = .black
    
    let items = [flexSpace, doneButton]
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    self.inputAccessoryView = doneToolbar
  }
  
  func showDatePicker(target: Any, doneAction: Selector) {
    // Create a UIDatePicker object and assign to inputView
    let screenWidth = UIScreen.main.bounds.width
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 215))
    datePicker.datePickerMode = .date
    datePicker.maximumDate = Date()
    if #available(iOS 13.4, *) {
      datePicker.preferredDatePickerStyle = .wheels
    }
    self.inputView = datePicker
    
    // Create a toolbar and assign it to inputAccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(cancelAction))
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: doneAction)
    [cancelButton, doneButton].forEach({ $0.tintColor = .black })
    toolBar.setItems([cancelButton, flexible, doneButton], animated: false)
    self.inputAccessoryView = toolBar
  }
  
  @objc func doneAction() {
    self.resignFirstResponder()
  }
  
  @objc func cancelAction() {
    self.resignFirstResponder()
  }
}
