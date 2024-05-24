//
//  APIErrorDTO+Mapping.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import Foundation

struct APIErrorDTO: Decodable, Error {
  private enum CodingKeys: String, CodingKey {
    case code, message, data
  }

  var code: String?
  var data: ErrorDataDTO?
  var message: String?
}

extension APIErrorDTO {
  func toDomain() -> AppError {
    var appError = AppError()
    appError.detail = message
    return appError
  }
}

struct ErrorDataDTO: Codable {
  var status: Int?
  enum CodingKeys: String, CodingKey {
    case status
  }
}

extension Error {
  func toDomain() -> AppError {
    var appError = AppError()
    appError.detail = localizedDescription
    return appError
  }
}
