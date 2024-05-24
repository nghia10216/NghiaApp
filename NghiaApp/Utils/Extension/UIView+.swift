//
//  UIViewExtensions.swift
//

import Foundation
import UIKit

extension UIView {
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var borderColor: UIColor {
    get {
      return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
    }
    
    set {
      self.layer.borderColor = newValue.cgColor
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    
    set {
      self.layer.cornerRadius = newValue
      self.clipsToBounds = true
    }
  }
  
  @IBInspectable var isMask: Bool {
    get {
      return layer.masksToBounds
    }
    
    set {
      self.layer.masksToBounds = newValue
    }
  }
  
  @IBInspectable var shadowColor: UIColor {
    get {
      return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
    }
    
    set {
      self.layer.shadowColor = newValue.cgColor
    }
  }
  
  @IBInspectable var shadowOffset: CGSize {
    get {
      return self.layer.shadowOffset
    }
    
    set {
      self.layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable var shadowOpacity: CGFloat {
    get {
      return self.layer.shadowOpacity.cgFloat
    }
    
    set {
      self.layer.shadowOpacity = newValue.float
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat {
    get {
      return self.layer.shadowRadius
    }
    
    set {
      self.layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable var shouldRasterize: Bool {
    get {
      return self.layer.shouldRasterize
    }
    
    set {
      self.layer.shouldRasterize = newValue
    }
  }
  
  func makeCorner(_ radius: CGFloat? = nil) {
    self.layer.cornerRadius = radius ?? height/2
    self.layer.masksToBounds = true
  }
  
  func removeBlurEffect() {
    let blurredEffectViews = self.subviews.filter { $0 is UIVisualEffectView }
    blurredEffectViews.forEach { $0.removeFromSuperview() }
  }
  
  func removeAllLayer() {
    self.layer.sublayers?.compactMap({$0}).forEach({ layer in
      layer.removeFromSuperlayer()
    })
  }
    
    func makeShadow(opacity: Float = 0.5, radius: CGFloat = 2, height: CGFloat = 3, color: UIColor = .gray, bottom: Bool = true, all: Bool = false) {
      self.layer.shadowOpacity = opacity
      self.layer.shadowRadius = radius
      self.layer.shadowColor = color.cgColor
      if all {
        self.layer.shadowOffset = .zero
      } else {
        let offset = bottom ? CGSize(width: 0, height: height): CGSize(width: height, height: 0)
        self.layer.shadowOffset = offset
      }
      self.layer.masksToBounds = false
    }
}

public extension UIView {
  static var loadNib: UINib {
    return UINib(nibName: "\(self)", bundle: nil)
  }
  
  func contentFromXib() -> UIView? {
    
    guard let contentView = type(of: self).loadNib.instantiate(withOwner: self, options: nil).last as? UIView else {
      return nil
    }
    
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(contentView)
    
    return contentView
  }
}

extension UIView {
  func makeBlur(style: UIBlurEffect.Style = .systemUltraThinMaterialDark) {
    //    if !UIAccessibility.isReduceTransparencyEnabled {
    //      let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
    //      let blurEffectView = UIVisualEffectView(effect: blurEffect)
    //      self.addSubview(blurEffectView)
    //      blurEffectView.snp.makeConstraints { (make) in
    //        make.edges.equalToSuperview()
    //      }
    //    } else {
    //      self.backgroundColor = .white
    //      self.alpha = 0.8
    //    }
  }
}

extension UIView {
  func addDashLine(width: CGFloat, color: CGColor) {
    let caShapeLayer = CAShapeLayer()
    caShapeLayer.strokeColor = color
    caShapeLayer.lineWidth = width
    caShapeLayer.lineDashPattern = [4,3]
    let cgPath = CGMutablePath()
    let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.width, y: 0)]
    cgPath.addLines(between: cgPoint)
    caShapeLayer.path = cgPath
    layer.addSublayer(caShapeLayer)
  }
}
