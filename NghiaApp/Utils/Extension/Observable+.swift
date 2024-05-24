import RxSwift
import RxCocoa
import UIKit

extension ObservableType where Element == Bool {
  /// Boolean not operator
  public func not() -> Observable<Bool> {
    return self.map(!)
  }
}

extension SharedSequenceConvertibleType {
  func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
    return map { _ in }
  }
}

extension ObservableType {
  func asDriverOnErrorJustComplete() -> Driver<Element> {
    return asDriver { _ in
      return Driver.empty()
    }
  }
  func mapToVoid() -> Observable<Void> {
    return map { _ in }
  }
}

protocol OptionalType {
  associatedtype Wrapped
  var optional: Wrapped? { get }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: OptionalType {
  internal func ignoreNil() -> Driver<Element.Wrapped> {
    return flatMap { value in
      value.optional.map { Driver<Element.Wrapped>.just($0) } ?? Driver<Element.Wrapped>.empty()
    }
  }
}

extension Driver {
  func flatMapLatest<T>(on scheduler: SchedulerType, completion: @escaping (Element) -> T) -> Driver<T> {
    return self.flatMapLatest { value in
      Observable
        .just(value)
        .observe(on: scheduler)
        .map(completion)
        .asDriverOnErrorJustComplete()
    }
  }
}

