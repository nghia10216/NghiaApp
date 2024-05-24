//
//  APIConfigure.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import Foundation

class DefaultAPIConfigure: APIConfigure {
    var debugger: DebuggerConfig = .none
    var host: String = ConfigurationKey.baseURL.value().unwrapped(or: "")

    static var defaultHeader: [String: String] {
      var headers: [String: String] = ["Content-Type": "application/json"]
      if let accessToken = UDKey<String>.token.value {
        debugPrint("Bearer \(accessToken )")
        headers["Authorization"] = "Bearer \(accessToken)"
      }
      return headers
    }
}
