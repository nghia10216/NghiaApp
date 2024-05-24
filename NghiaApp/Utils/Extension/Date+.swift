//
//  DateExtensions.swift
//

import Foundation

extension Date {
  public enum DateFormat: String {
    case ddMMyyyy = "dd/MM/yyyy"
    case yyyyMMdd = "yyyy-MM-dd"
    case ddMMyy = "dd/MM/yy"
    case MMyy = "MM/yy"
    case MMyyyy = "MM/yyyy"
    case yyyyMMddhhmmss = "yyyy-MM-dd hh:mm:ss"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case ddMMyyyyhhMMa = "dd MMM yyyy hh:mma"
    case ddMMMyyyy = "dd MMM yyyy"
    case MMMdYYYY = "MMM d, YYYY"
    case MMddYYYYHyphen = "MM-dd-yyyy"
    case yyyyMMddTHHmmssSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case eee = "EEE"
  }
  
  public init(_ dateString: String, format: DateFormat, localized: Bool = true) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    dateFormatter.timeZone = localized ? TimeZone.current : TimeZone(abbreviation: "UTC")
    dateFormatter.locale = Locale(identifier: Locale.current.identifier)
    
    if let date = dateFormatter.date(from: dateString) {
      self.init(timeInterval: 0, since: date)
    } else {
      self.init(timeInterval: 0, since: Date())
    }
  }
  
  func format(to format: DateFormat, localized: Bool = true) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = localized ? TimeZone.current : TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = format.rawValue
    return dateFormatter.string(from: self)
  }

  static func date(from date: String, format: DateFormat, localized: Bool = true) -> Self? {
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = localized ? TimeZone.current : TimeZone(abbreviation: "UTC")
    formatter.locale = Locale(identifier: Locale.current.identifier)
    return formatter.date(from: date)
  }

  func yearAndWeek() -> (year: Int, week: Int) {
      let calendar = Calendar.current
      let year = calendar.component(.year, from: self)
      let week = calendar.component(.weekOfYear, from: self)
      return (year, week)
  }
}
