//
//  GetWorkoutsListUsecase.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import RxSwift
import Swinject

protocol GetWorkoutsListUsecase {
  func getWorkoutsList(query: WorkoutQuery) -> Observable<Result<Workouts, AppError>>
}

final class DefaultGetWorkoutsListUsecase: GetWorkoutsListUsecase {

  private let workoutsRepository = Container.getService(WorkoutsRepository.self)

  func getWorkoutsList(query: WorkoutQuery) -> RxSwift.Observable<Result<Workouts, AppError>> {
    return .create { signal -> Disposable in
      self.workoutsRepository?.getWorkoutsList(query: query) { (output, error) in
        if let error = error {
          signal.onNext(.failure(error))
        } else if let result = output {
          signal.onNext(.success(result))
        }
        signal.onCompleted()
      }
      return Disposables.create()
    }
  }
}
