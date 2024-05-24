//
//  Workouts.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 23/05/2024.
//

import Foundation

struct Workouts {
  let workouts: [Workout]
}

struct Workout: Equatable {
  let id: String
  var trainer, client: String?
  var assignments: [Assignment]
  var day: Date?
}

struct Assignment: Equatable {
  enum Status: Int {
    case doing
    case complete
    case missed
  }

  let id: String
  var status: Status
  let client, title: String?
  let exercisesCompleted, exercisesCount: Int?
  let day, date, startDate, endDate: Date?
  let duration, rating: Int?
  var isComplete: Bool
}
