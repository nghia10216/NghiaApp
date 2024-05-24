//
//  BaseViewController.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import UIKit

class BaseViewController: UIViewController {

  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bindingData()
    configUI()
    setupAction()
  }

  func setup() {}
  func bindingData() {}
  func configUI() {}
  func setupAction() {}
}
