//
//  AppDefine.swift
//

import Foundation
import UIKit

typealias Completion = () -> Void
typealias JSON = [String: Any]
typealias LanguageKey = AppDefine.LanguageKey
typealias Message = AppDefine.Message
typealias Title = AppDefine.Title
typealias Key = AppDefine.DefaultKey
typealias Image = AppDefine.Image

enum AppDefine {
  enum Message: String {
    var desc: String {
      return rawValue
    }
    
    case error = ""
  }
  
  enum Title: String {
    var desc: String {
      return rawValue
    }
    
    case appName = ""
    
    // Screen title
    case social = "Social"
    case profileSetting = "Profile Settings"
  }
}

extension AppDefine {
  
  enum DefaultKey: String {
    var desc: String {
      return rawValue
    }
    case logged = "kLogged"
  }
}
