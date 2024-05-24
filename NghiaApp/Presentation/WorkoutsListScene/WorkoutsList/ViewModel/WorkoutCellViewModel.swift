//
//  WorkoutCellViewModel.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 23/05/2024.
//

import RxDataSources
import Foundation

struct WorkoutItem: Equatable {
  let id = UUID().uuidString
  var workout: Workout?
  let day: Date
  let differentDay: Int
}

extension WorkoutItem: IdentifiableType {
  typealias Identity = String

  var identity: String {
    self.id
  }
}

extension WorkoutItem {
  static func currentWorkoutItems(date: Date) -> [Self] {
    var calendar = Calendar.current
    calendar.firstWeekday = 2
    guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else {
      return []
    }
  
    return (0..<7).compactMap { dayOffset in
      guard let weekDay = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) else {
        return nil
      }

      return WorkoutItem(
        day: weekDay,
        differentDay: weekDay.day - date.day
      )
    }
  }
}

struct AssignmentItem: Equatable {
  var assignment: Assignment
  var differentDay: Int
}

extension AssignmentItem: IdentifiableType {
  typealias Identity = String

  var identity: String {
    assignment.id
  }
}

struct AssignmentSection {
  var items: [AssignmentItem]
}

extension AssignmentSection: SectionModelType {
  var identity: Int {
    return 0
  }

  typealias Identity = Int
  typealias Item = AssignmentItem

  init(original: AssignmentSection, items: [AssignmentItem]) {
      self = original
      self.items = items
  }
}

struct WorkoutSection {
    var items: [WorkoutItem]
}

extension WorkoutSection: SectionModelType {
    var identity: Int {
        return 0
    }

    typealias Identity = Int
    typealias Item = WorkoutItem

    init(original: WorkoutSection, items: [WorkoutItem]) {
        self = original
        self.items = items
    }
}
