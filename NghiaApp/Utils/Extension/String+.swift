//
//  StringExtensions.swift
//

import Foundation

// MARK: - Check validate
extension String {
  var isValidEmail: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }
  
  var isValidPhone: Bool {
    let phoneRegex = "^[0-9]{6,14}$"
    return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self)
  }
  
  var isValidPassword: Bool {
    // swiftlint:disable line_length
//    let passwordRegex = "^(?=[A-Za-z0-9@$!%*#?&]*[A-Za-z])(?=[A-Za-z0-9@$!%*#?&]*[0-9])(?=[A-Za-z0-9@$!%*#?&]*[@$!%*#?&])[A-Za-z0-9@$!%*#?&]{8,}$"
//    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    return passwordValidation(password: self)
  }
    
    public func passwordValidation(password: String) -> Bool {
      // Password should be at least 8 characters long
      let lengthResult = password.count >= 8
      
      // Password should contain at least one uppercase latter
      let capsRegEx  = ".*[A-Z]+.*"
      let capsTest = NSPredicate(format:"SELF MATCHES %@", capsRegEx)
      let capsResult = capsTest.evaluate(with: password)
      
      // at least one lowercase latter
      let lowerRegEx  = ".*[a-z]+.*"
      let lowerTest = NSPredicate(format:"SELF MATCHES %@", lowerRegEx)
      let lowerResult = lowerTest.evaluate(with: password)
      
      // at least one numnber
      let numberRegEx  = ".*[0-9]+.*"
      let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
      let numberResult = numberTest.evaluate(with: password)
      
      // and at least one special character
      let specialChars  = CharacterSet(charactersIn: "^$*.[]{}()?-\"!@#%&/\\,><\':;|_~`")
      let specialResult = password.rangeOfCharacter(from: specialChars) != nil
      
      return lengthResult && capsResult && lowerResult && numberResult && specialResult
    }
}

extension String {
  func trim() -> String {
    return trimmingCharacters(in: CharacterSet.whitespaces)
  }

  func range(from nsRange: NSRange) -> Range<String.Index>? {
    guard
      let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
      let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
      let from = String.Index(from16, within: self),
      let to = String.Index(to16, within: self)
      else { return nil }
    return from ..< to
  }
}
