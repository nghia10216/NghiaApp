//
//  DayDataResponseDTO+Mapping.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 23/05/2024.
//

import Foundation

// MARK: - Data Transfer Object
struct WorkoutsResponseDTO: Decodable {
  enum CodingKeys: String, CodingKey {
    case workouts = "day_data"
  }
  let workouts: [WorkoutDTO]?
}

extension WorkoutsResponseDTO {
  struct WorkoutDTO: Decodable {
    let id: String?
    let assignments: [AssiginmentDTO]?
    let trainer, client, day, date: String?

    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case assignments, trainer, client, day, date
    }
  }
}

extension WorkoutsResponseDTO.WorkoutDTO {
  struct AssiginmentDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
      case id = "_id"
      case status, client, title, day, date
      case exercisesCompleted = "exercises_completed"
      case exercisesCount = "exercises_count"
      case startDate = "start_date"
      case endDate = "end_date"
      case duration, rating
      case isComplete
    }

    let id: String?
    let status: Int
    let client, title, day, date: String?
    let exercisesCompleted, exercisesCount: Int?
    let startDate, endDate: String?
    let duration, rating: Int?
    let isComplete: Bool?
  }
}

// MARK: - Mappings to Domain
extension WorkoutsResponseDTO {
  func toDomain() -> Workouts {
    .init(workouts: workouts?.map {
      $0.toDomain()
    } ?? [])
  }
}

extension WorkoutsResponseDTO.WorkoutDTO {
  func toDomain() -> Workout {
    return .init(
      id: id.unwrapped(or: ""),
      trainer: trainer,
      client: client,
      assignments: assignments?.map { $0.toDomain() } ?? [],
      day: Date.date(from: day.unwrapped(or: ""), format: .MMddYYYYHyphen)
    )
  }
}

extension WorkoutsResponseDTO.WorkoutDTO.AssiginmentDTO {
  func toDomain() -> Assignment {
    .init(
      id: id.unwrapped(or: ""),
      status: Assignment.Status(rawValue: status).unwrapped(or: .doing),
      client: client,
      title: title,
      exercisesCompleted: exercisesCompleted,
      exercisesCount: exercisesCount,
      day: Date.date(from: day.unwrapped(or: ""), format: .MMddYYYYHyphen),
      date: Date.date(from: date.unwrapped(or: ""), format: .yyyyMMddTHHmmssSSSZ),
      startDate: Date.date(from: startDate.unwrapped(or: ""), format: .yyyyMMddTHHmmssSSSZ),
      endDate: Date.date(from: endDate.unwrapped(or: ""), format: .yyyyMMddTHHmmssSSSZ),
      duration: duration,
      rating: rating,
      isComplete: isComplete.unwrapped(or: false)
    )
  }
}
