import UIKit
import RxSwift
import RxCocoa

protocol ViewModelTransformable {
  associatedtype Input
  associatedtype Output
  func transform(input: Input) -> Output
}

class ViewModel: NSObject {
  
  var disposeBag: DisposeBag!
  let appError = PublishRelay<AppError>()
  var activity = ActivityIndicator()
  
  override init() {
    disposeBag = DisposeBag()
    super.init()
  }
  
  deinit {
    #if DEBUG
    print("\(String(describing: self)) deinit.")
    #endif
  }
}
