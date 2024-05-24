//
//  GetWorkoutsListInput.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import Foundation

class GetWorkoutsListInput: APIInput {
  var requestType: RequestType = .get
  var pathToApi: String = APIEndpoints.getWorkoutsList.path

  func makeRequestableBody() -> [String: Any] {
    return [:]
  }

  func makeRequestableHeader() -> [String: String] {
    return DefaultAPIConfigure.defaultHeader
  }
}
