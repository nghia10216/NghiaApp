//
//  UpdateAssignmentUsecase.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 23/05/2024.
//

import Foundation
import Swinject
import RxSwift

protocol UpdateAssignmentUsecase {
  func udateAssignment(query: AssignmentQuery)
}

final class DefaultUpdateAssignmentUsecase: UpdateAssignmentUsecase {

  private let workoutsRepository = Container.getService(WorkoutsRepository.self)

  func udateAssignment(query: AssignmentQuery) {
    workoutsRepository?.updateAssignment(query: query)
  }
}

