//
//  Data+Injection.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//
import Swinject

extension Container {

  static let defaultContainer = Container()

  static func registerService() {
    defaultContainer.register(NetworkProvider.self) { _ in
      return DefaultNetworkProvider(with: DefaultAPIConfigure())
    }

    defaultContainer.register(WorkoutsResponseStorage.self) { _ in
      return CoreDataWorkoutsResponseStorage()
    }

    defaultContainer.register(WorkoutsRepository.self) { resolver in
      return DefaultWorkoutsRepository(
        networkProvider: resolver.resolve(NetworkProvider.self)!,
        cache: resolver.resolve(WorkoutsResponseStorage.self)!)
    }
  }

  static func getService<T>(_ type: T.Type) -> T? {
    return defaultContainer.resolve(type)
  }
}
