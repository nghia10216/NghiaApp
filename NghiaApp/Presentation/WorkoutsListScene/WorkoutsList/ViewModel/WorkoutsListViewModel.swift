//
//  WorkoutsListViewModel.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//
import Foundation
import RxCocoa
import RxSwift

final class WorkoutsListViewModel: ViewModel {

  // MARK: Navigator
  private let navigator: WorkoutsListNavigator

  // MARK: Usecases
  private let getWorkoutsListUsecase: GetWorkoutsListUsecase
  private let updateAssignmentUsecase: UpdateAssignmentUsecase
  // MARK: Subjects
  private let workoutsListSections = BehaviorRelay<[WorkoutSection]>(value: [])
  private let date = Date()

  // MARK: - Initialize
  init(navigator: WorkoutsListNavigator) {
    self.navigator = navigator
    getWorkoutsListUsecase = DefaultGetWorkoutsListUsecase()
    updateAssignmentUsecase = DefaultUpdateAssignmentUsecase()
    super.init()
    setupData()
  }

  // MARK: - Private
  private func setupData() {
    workoutsListSections.accept([WorkoutSection(items: WorkoutItem.currentWorkoutItems(date: date))])
  }

  private func getWorkoutsList(getWorkoutsListTrigger: Driver<Void>) {
    getWorkoutsListTrigger
      .flatMapLatest { [unowned self] in
        let (year, week) = self.date.yearAndWeek()
        return self.getWorkoutsListUsecase.getWorkoutsList(query: .init(week: week, year: year))
          .trackActivity(self.activity)
          .asDriverOnErrorJustComplete()
      }
      .drive(onNext: { [unowned self] in
        switch $0 {
        case .success(let workoutsList):
          self.handleWorkoutsList(workoutsList: workoutsList)
        case .failure(let error):
          self.appError.accept(error)
        }
      })
      .disposed(by: disposeBag)
  }

  private func handleWorkoutsList(workoutsList: Workouts) {
    let workouts = workoutsList.workouts
    var workoutItems = workoutsListSections.value.first?.items ?? []
    workoutItems.enumerated().forEach { index, value in
      if let workout = workouts.first(where: {
        $0.day == value.day
      }) {
        workoutItems[index].workout = workout
      }
    }
    self.workoutsListSections.accept([WorkoutSection(items: workoutItems)])
  }

  private func toggleAssignment(
    assignmentTrigger: Driver<(excersiseIndexPath: IndexPath, assignmentIndexPath: IndexPath)>
  ) {
    assignmentTrigger
      .drive(onNext: { [unowned self] indexPaths in
        let (excersiseIndexPath, assignmentIndexPath) = indexPaths
        var workoutItems = workoutsListSections.value.first?.items ?? []
        if var assignment = workoutItems[excersiseIndexPath.row]
          .workout?
          .assignments[assignmentIndexPath.row] {
          assignment.isComplete.toggle()
          self.updateAssignmentUsecase.udateAssignment(query: .init(id: assignment.id, isComplete: assignment.isComplete))
          workoutItems[excersiseIndexPath.row].workout?.assignments[assignmentIndexPath.row] = assignment
          self.workoutsListSections.accept([WorkoutSection(items: workoutItems)])
        }
      })
      .disposed(by: disposeBag)
  }
}

extension WorkoutsListViewModel: ViewModelTransformable {

  func transform(input: Input) -> Output {
    getWorkoutsList(getWorkoutsListTrigger: input.getWorkoutsListTrigger)
    toggleAssignment(assignmentTrigger: input.assignmentTrigger)
    return.init(
      workoutsListSections: workoutsListSections.asDriver(),
      appError: appError.asDriverOnErrorJustComplete()
    )
  }

  struct Input {
    let getWorkoutsListTrigger: Driver<Void>
    let assignmentTrigger: Driver<(excersiseIndexPath: IndexPath, assignmentIndexPath: IndexPath)>
  }

  struct Output {
    let workoutsListSections: Driver<[WorkoutSection]>
    let appError: Driver<AppError>
  }
}
