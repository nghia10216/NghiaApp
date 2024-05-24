//
//  DefaultWorkoutsRepository.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import Foundation

final class DefaultWorkoutsRepository {
  private let networkProvider: NetworkProvider
  private let cache: WorkoutsResponseStorage

  init(networkProvider: NetworkProvider, cache: WorkoutsResponseStorage) {
    self.networkProvider = networkProvider
    self.cache = cache
  }
}

extension DefaultWorkoutsRepository: WorkoutsRepository {
  func updateAssignment(query: AssignmentQuery) {
    cache.updateAssignment(query: query)
  }
  
  func getWorkoutsList(query: WorkoutQuery, completionHandler: @escaping (Workouts?, AppError?) -> Void) {
    let requestDTO = WorkoutsRequestDTO(week: query.week, year: query.year)
    cache.getResponse(for: requestDTO) { [weak self] result in
      if case let .success(responseDTO?) = result {
        completionHandler(responseDTO.toDomain(), nil)
      } else {
        let request = GetWorkoutsListAPI(with: GetWorkoutsListInput(),
                                       and: GetWorkoutsListOutput())
        self?.networkProvider.load(api: request, onComplete: { response in
          let result = response.getOutput()?.result
          if let result = result {
            self?.cache.save(response: result, for: requestDTO)
          }
          completionHandler(result?.toDomain(), nil)
        }, onRequestError: { response in
          completionHandler(nil, response.getOutput()?.error?.toDomain())
        }, onServerError: { (error) in
          completionHandler(nil, error?.toDomain())
        })
      }
    }
  }
}
