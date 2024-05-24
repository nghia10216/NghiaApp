//
//  GetWorkoutsListAPI.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import Foundation

class GetWorkoutsListAPI: Requestable {
  func getOutput() -> GetWorkoutsListOutput? {
    return self.output
  }
  var input: GetWorkoutsListInput
  var output: GetWorkoutsListOutput
  init(with input: GetWorkoutsListInput,
       and output: GetWorkoutsListOutput) {
    self.input = input
    self.output = output
  }
}
