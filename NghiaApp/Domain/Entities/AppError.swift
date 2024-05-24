//
//  AppError.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import Foundation

struct AppError: Error {
  var status: String?
  var errors: [String]?
  var httpErrorMessage: String?
  var detail: String?
}

extension AppError {
  var actualErrorMessage: String {
    errors?.reduce("", { $0 + "\n" + $1}) ?? detail ?? "Uknown Error"
  }
}
