//
//  Application.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import UIKit

final class Application {
  static let shared = Application()

  private init() {}

  func configureMainInterface(in window: UIWindow) {
    let workoutsListNavigationController = UINavigationController()
    let workoutsListNavigator = DefaultWorkoutsListNavigator(navigation: workoutsListNavigationController)
    window.rootViewController = workoutsListNavigationController
    workoutsListNavigator.toWorkoutsList()
  }
}
