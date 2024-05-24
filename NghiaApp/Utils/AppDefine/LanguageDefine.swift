//
//  LanguageDefine.swift
//
//  Copyright © 2021 KST. All rights reserved.
//

import Foundation

extension AppDefine {
  enum LanguageKey: String, CaseIterable {
    case excerscise = "EXCERCISE"
    case excerscises = "EXCERCISES"
    case completed = "COMPLETED"
    case missed = "MISSED"

    var desc: String {
      rawValue
    }
    
    var text: String {
        rawValue.localized()
    }

    static subscript(_ key: LanguageKey) -> String {
        let keys = LanguageKey.allCases.filter({ $0 == key })
        return keys.first!.text
    }
  }
}
