import Foundation
import CoreGraphics
import NVActivityIndicatorView

protocol LoadingService {
  func showLoading()
  func hideLoading()
}

class DefaultLoadingService: LoadingService {
    func showLoading() {
        DispatchQueue.main.async {
            let activityData = ActivityData(size: CGSize(width: 100, height: 100),
                                            type: NVActivityIndicatorType.ballScale,
                                            color: #colorLiteral(red: 0.8784313725, green: 0.6549019608, blue: 0.05490196078, alpha: 1))
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }
}
