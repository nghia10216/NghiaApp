//
//  UICollectionViewExtensions.swift
//
//  Copyright © 2021 KST. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

extension UICollectionView {
  func willDisplayCell<T: UICollectionViewCell>(_ aClass: T.Type) -> Driver<(T?, IndexPath)> {
    return self.rx.willDisplayCell.map { cell, indexPath -> (T?, IndexPath) in
      let cell = self.dequeueReusableCell(T.self, for: indexPath)
      return (cell, indexPath)
    }.asDriverOnErrorJustComplete()
  }
}
