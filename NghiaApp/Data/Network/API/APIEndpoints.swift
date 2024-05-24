//
//  APIEndpoints.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import Foundation

enum APIEndpoints {
  case getWorkoutsList

  var path: String {
    switch self {
    case .getWorkoutsList:
      return "/workouts"
    }
  }
}
