//
//  CoreDataWorkoutsResponseStorage.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 23/05/2024.
//

import Foundation
import CoreData

final class CoreDataWorkoutsResponseStorage {
  private let coreDataStorage: CoreDataStorage

  init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
    self.coreDataStorage = coreDataStorage

  }

  // MARK: - Private
  private func fetchRequest(
    for requestDto: WorkoutsRequestDTO
  ) -> NSFetchRequest<WorkoutsRequestEntity> {
    let request: NSFetchRequest = WorkoutsRequestEntity.fetchRequest()
    request.predicate = NSPredicate(format: "%K = %d AND %K = %d",
                                    #keyPath(WorkoutsRequestEntity.week), requestDto.week,
                                    #keyPath(WorkoutsRequestEntity.year), requestDto.year)
    return request
  }

  private func fetchAssignment(id: String) -> NSFetchRequest<AssignmentResponseEntity> {
    let request: NSFetchRequest = AssignmentResponseEntity.fetchRequest()
    request.predicate =  NSPredicate(format: "id == %@", id)
    return request
  }

  private func deleteResponse(
    for requestDto: WorkoutsRequestDTO,
    in context: NSManagedObjectContext
  ) {
    let request = fetchRequest(for: requestDto)

    do {
      if let result = try context.fetch(request).first {
        context.delete(result)
      }
    } catch {
      print(error)
    }
  }
}

extension CoreDataWorkoutsResponseStorage: WorkoutsResponseStorage {

  func getResponse(
    for requestDto: WorkoutsRequestDTO,
    completion: @escaping (Result<WorkoutsResponseDTO?, Error>) -> Void
  ) {
    coreDataStorage.performBackgroundTask { context in
      do {
        let fetchRequest = self.fetchRequest(for: requestDto)
        let requestEntity = try context.fetch(fetchRequest).first

        completion(.success(requestEntity?.response?.toDTO()))
      } catch {
        completion(.failure(CoreDataStorageError.readError(error)))
      }
    }
  }

  func save(
    response responseDto: WorkoutsResponseDTO,
    for requestDto: WorkoutsRequestDTO
  ) {
    coreDataStorage.performBackgroundTask { context in
      do {
        self.deleteResponse(for: requestDto, in: context)

        let requestEntity = requestDto.toEntity(in: context)
        requestEntity.response = responseDto.toEntity(in: context)

        try context.save()
      } catch {
        // TODO: - Log to Crashlytics
        debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
      }
    }
  }

  func updateAssignment(query: AssignmentQuery) {
    coreDataStorage.performBackgroundTask { context in
      do {
        let fetchRequest = self.fetchAssignment(id: query.id)
        let requestEntity = try context.fetch(fetchRequest).first
        requestEntity?.setValue(query.isComplete, forKey: "isLocalComplete")
        try context.save()
      } catch {
        debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
      }
    }
  }

}
