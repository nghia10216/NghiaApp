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
    let moviesListNavigationController = UINavigationController()
    let moviesListNavigator = DefaultWorkoutsListNavigator(navigation: moviesListNavigationController)
    window.rootViewController = moviesListNavigationController
    moviesListNavigator.toMoviesList()
  }
}
