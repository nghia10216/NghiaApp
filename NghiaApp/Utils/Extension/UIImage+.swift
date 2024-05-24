import UIKit
import CoreGraphics
import AVFoundation
import Kingfisher
import Photos
import MobileCoreServices
import ImageIO

public extension UIImageView {
  func imageFromURL(path: String) {
    let isImageCached = ImageCache.default.imageCachedType(forKey: path)
    if isImageCached.cached, let image = ImageCache.default.retrieveImageInMemoryCache(forKey: path) {
      self.image = image
    } else {
      guard let url = URL(string: path) else { return }
      let resource = KF.ImageResource(downloadURL: url, cacheKey: path)
      self.kf.setImage(with: resource)
    }
  }
  
  func addBlurEffect(withAlpha alpha: CGFloat = 1) {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.alpha = alpha
    blurEffectView.frame = self.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(blurEffectView)
  }
}

public extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: (image?.cgImage)!)
  }
  
  func makeIcon(with color: UIColor, and renderMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage? {
    return self.withTintColor(color).withRenderingMode(renderMode)
  }
}

public extension UIImage {
  
  func scaled(_ newSize: CGSize) -> UIImage {
    guard size != newSize else {
      return self
    }
    
    let ratio = min(newSize.width / size.width, newSize.height / size.height)
    let width = size.width * ratio
    let height = size.height * ratio
    
    let scaledRect = CGRect(x: 0, y: 0, width: width, height: height)
    
    UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0)
    defer { UIGraphicsEndImageContext() }
    
    draw(in: scaledRect)
    
    return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
  }
  
  enum JPEGQuality: CGFloat {
    case lowest  = 0.05
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
  }
  
  /// Returns the data for the specified image in JPEG format.
  /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory..
  func jpeg(_ quality: JPEGQuality = .highest) -> Data {
    return autoreleasepool(invoking: { () -> Data in
      let data = NSMutableData()
      let options: NSDictionary = [kCGImagePropertyOrientation: imageOrientation,
                                      kCGImagePropertyHasAlpha: true,
                    kCGImageDestinationLossyCompressionQuality: quality.rawValue]
      if let cgImage = cgImage, let imgDest = CGImageDestinationCreateWithData(data as CFMutableData, kUTTypeJPEG, 1, nil) {
        CGImageDestinationAddImage(imgDest, cgImage, options)
        CGImageDestinationFinalize(imgDest)
        return data as Data
      }
      return self.jpegData(compressionQuality: quality.rawValue) ?? Data()
    })
  }
  
  func gifData() -> Data? {
    return self.kf.gifRepresentation()
  }
  
  func toData(_ quality: JPEGQuality = .highest, type: ImageType) -> Data {
    guard cgImage != nil else { return jpeg(quality) }
    let options: NSDictionary = [kCGImagePropertyOrientation: imageOrientation,
                                    kCGImagePropertyHasAlpha: true,
                  kCGImageDestinationLossyCompressionQuality: quality.rawValue]
    let data = toData(options: options, type: type.value)
    
    return data ?? jpeg(quality)
  }
  
  func toData(options: NSDictionary, type: CFString) -> Data? {
    guard let cgImage = cgImage else { return nil }
    return autoreleasepool { () -> Data? in
      let data = NSMutableData()
      guard let imageDestination = CGImageDestinationCreateWithData(data as CFMutableData, type, 1, nil)
      else { return nil }
      CGImageDestinationAddImage(imageDestination, cgImage, options)
      CGImageDestinationFinalize(imageDestination)
      return data as Data
    }
  }
}

// https://developer.apple.com/documentation/mobilecoreservices/uttype/uti_image_content_types
public enum ImageType: String {
  case image // abstract image data
  case jpeg                       // JPEG image
  case jpg                        // JPG image
  case jpeg2000                   // JPEG-2000 image
  case tiff                       // TIFF image
  case tif                        // TIFF image
  case pict                       // Quickdraw PICT format
  case gif                        // GIF image
  case png                        // PNG image
  case quickTimeImage             // QuickTime image format (OSType 'qtif')
  case appleICNS                  // Apple icon data
  case bmp                        // Windows bitmap
  case ico                        // Windows icon data
  case rawImage                   // base type for raw image data (.raw)
  case scalableVectorGraphics     // SVG image
  case livePhoto                  // Live Photo
  
  var value: CFString {
    switch self {
    case .image: return kUTTypeImage
    case .jpeg, .jpg: return kUTTypeJPEG
    case .jpeg2000: return kUTTypeJPEG2000
    case .tiff, .tif: return kUTTypeTIFF
    case .pict: return kUTTypePICT
    case .gif: return kUTTypeGIF
    case .png: return kUTTypePNG
    case .quickTimeImage: return kUTTypeQuickTimeImage
    case .appleICNS: return kUTTypeAppleICNS
    case .bmp: return kUTTypeBMP
    case .ico: return kUTTypeICO
    case .rawImage: return kUTTypeRawImage
    case .scalableVectorGraphics: return kUTTypeScalableVectorGraphics
    case .livePhoto: return kUTTypeLivePhoto
    }
  }
  
  public var objectType: String {
    switch self {
    case .tiff, .tif: return "image/tiff"
    case .gif: return "image/gif"
    case .png: return "image/png"
    case .bmp: return "image/bmp"
    case .ico: return "image/x-icon"
    default: return "image/jpeg"
    }
  }
}
