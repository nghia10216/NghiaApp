//
//  GetWorkoutsListOutput.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import Foundation

class GetWorkoutsListOutput: APIOutput {
  var result: WorkoutsResponseDTO?
  var error: APIErrorDTO?
  var systemError: Error?
  var responseParser: Parseable = CodeableParser<ResultType>()
  var errorParser: Parseable = CodeableParser<ErrorType>()
}
