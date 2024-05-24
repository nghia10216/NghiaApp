//
//  WorkoutsResponseStorage.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 23/05/2024.
//

import Foundation

protocol WorkoutsResponseStorage {
  func getResponse(for requestDto: WorkoutsRequestDTO,
                   completion: @escaping (Result<WorkoutsResponseDTO?, Error>) -> Void)
  func save(
    response responseDto: WorkoutsResponseDTO,
    for requestDto: WorkoutsRequestDTO
  )

  func updateAssignment(query: AssignmentQuery)
}
