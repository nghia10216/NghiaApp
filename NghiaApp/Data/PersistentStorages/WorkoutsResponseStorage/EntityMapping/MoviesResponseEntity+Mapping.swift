import Foundation
import CoreData

extension WorkoutsResponseEntity {
  func toDTO() -> WorkoutsResponseDTO {
    return .init(
      workouts: workouts?.allObjects.map {
        ($0 as! WorkoutResponseEntity).toDTO()
      } ?? []
    )
  }
}

extension WorkoutResponseEntity {
  func toDTO() -> WorkoutsResponseDTO.WorkoutDTO {
    return .init(
      id: id,
      assignments: assignments?.allObjects.map {
        ($0 as! AssignmentResponseEntity).toDTO()
      } ?? [],
      trainer: nil,
      client: nil,
      day: day,
      date: date
    )
  }
}

extension AssignmentResponseEntity {
  func toDTO() -> WorkoutsResponseDTO.WorkoutDTO.AssiginmentDTO {
    return .init(
      id: id,
      status: Int(status),
      client: nil,
      title: title,
      day: day,
      date: date,
      exercisesCompleted: 0,
      exercisesCount: Int(exercisesCount),
      startDate: nil,
      endDate: nil,
      duration: 0,
      rating: 0, 
      isComplete: isLocalComplete
    )
  }
}

extension WorkoutsRequestDTO {
  func toEntity(in context: NSManagedObjectContext) -> WorkoutsRequestEntity {
    let entity: WorkoutsRequestEntity = .init(context: context)
    entity.week = Int16(week)
    entity.year = Int16(year)
    return entity
  }
}


extension WorkoutsResponseDTO {
  func toEntity(in context: NSManagedObjectContext) -> WorkoutsResponseEntity {
    let entity: WorkoutsResponseEntity = .init(context: context)
    workouts?.forEach {
      entity.addToWorkouts($0.toEntity(in: context))
    }
    return entity
  }
}

extension WorkoutsResponseDTO.WorkoutDTO {
  func toEntity(in context: NSManagedObjectContext) -> WorkoutResponseEntity {
    let entity: WorkoutResponseEntity = .init(context: context)
    entity.id = id
    entity.date = date
    entity.day = day
    assignments?.forEach {
      entity.addToAssignments($0.toEntity(in: context))
    }
    return entity
  }
}

extension WorkoutsResponseDTO.WorkoutDTO.AssiginmentDTO {
  func toEntity(in context: NSManagedObjectContext) -> AssignmentResponseEntity {
    let entity: AssignmentResponseEntity = .init(context: context)
    entity.id = id
    entity.date = date
    entity.day = day
    if let exercisesCount = exercisesCount {
      entity.exercisesCount = Int16(exercisesCount)
    }
    entity.status = Int16(status)
    entity.title = title
    return entity
  }
}
