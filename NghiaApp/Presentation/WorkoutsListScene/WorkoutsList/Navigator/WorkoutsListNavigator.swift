//
//  WorkoutsListNavigator.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import UIKit

protocol WorkoutsListNavigator {
  func toWorkoutsList()
}

final class DefaultWorkoutsListNavigator: WorkoutsListNavigator {
  private unowned var navigation: UINavigationController

  init(navigation: UINavigationController) {
    self.navigation = navigation
  }

  func toWorkoutsList() {
    let vm = WorkoutsListViewModel(navigator: self)
    let vc = WorkoutsListViewController(viewModel: vm)
    navigation.pushViewController(vc, animated: true)
  }
}
