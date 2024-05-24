//
//  WorkoutsRepository.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import Foundation

protocol WorkoutsRepository {
  func getWorkoutsList(query: WorkoutQuery, completionHandler: @escaping (_ output: Workouts?, _ error: AppError?) -> Void)
  func updateAssignment(query: AssignmentQuery)
}
