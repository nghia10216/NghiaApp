//
//  UDHelper.swift
//

import Foundation
import CryptoSwift

public protocol UD {
  
  // swiftlint:disable type_name
  associatedtype T
  var rawValue: String {get}
}

public extension UD {
  
  // MARK: - Getter and Setter
  var value: T? {
    let val = UserDefaults.standard.value(forKey: key) as? T
    return decrypt(val: val)
  }
  
  func set(ud: UserDefaults? = UserDefaults.standard, _ val: T?) {
    let value = encrypt(val)
    ud?.set(value, forKey: key)
  }
  
  var ud: UserDefaults? {
    return UserDefaults(suiteName: key)
  }
  
  func value(ud: UserDefaults?) -> T? {
    let val = ud?.value(forKey: key) as? T
    return decrypt(val: val)
  }
  
  // MARK: - Private handlers
  private var key: String {
    return rawValue
  }
  
  private var secureKey: String {
    return key.count > 16 ? String(key.prefix(16)) : key + String(repeating: "k", count: 16 - key.count)
  }
  
  // MARK: - Encrypt and Decrypt String using AES Method
  private func encrypt(_ val: T?) -> T? {
    guard let value = val as? String else { return val }
    do {
      let iv = AES.randomIV(AES.blockSize)
      let aes = try AES(key: secureKey.md5().bytes, blockMode: CBC(iv: iv))
      let encrypted = try aes.encrypt(value.bytes)
      let encryptedK = Data(encrypted)
      var encryptedKIV = Data(iv)
      encryptedKIV.append(encryptedK)
      return encryptedKIV.base64EncodedString() as? T
    } catch let err {
      print(err)
      return val
    }
  }
  
  private func decrypt(val: T?) -> T? {
    guard let value = val as? String else { return val }
    do {
      
      guard let data = Data(base64Encoded: value) else { return val }
      let count = [UInt8](data).count
      guard count > AES.blockSize else { return val }
      let iv = Array([UInt8](data)[0 ..< AES.blockSize])
      let bytes = Array([UInt8](data)[AES.blockSize ..< count])
      let aes = try AES(key: secureKey.md5().bytes, blockMode: CBC(iv: iv))
      let decrypted = try aes.decrypt(bytes)
      return String(bytes: decrypted, encoding: .utf8) as? T
    } catch let err {
      print(err)
      return val
    }
  }
}

/// for dealling with UserDefault
public enum UDKey<T>: String, UD {
  
  // MARK: - Usecases
  case example = "EXAMPLE"
  
  // Authentication
  case token = "TOKEN"
  case isRemember = "IS_REMEMBER"
  case isLogged = "IS_LOGGED"
  case authToken = "com.rfx.academy.auth_token"
  case authUser = "com.rfx.academy.auth_user"
  case userNiceName = "com.rfx.academy.user_nice_name"
}

class UDHelper {
  static var isRemember: Bool {
    get {
      return UDKey<Bool>.isRemember.value.ignoreNil()
    }
    
    set {
      UDKey.isRemember.set(newValue)
    }
  }
  
  static var isLogged: Bool {
    get {
      return UDKey<Bool>.isLogged.value.ignoreNil()
    }
    set {
      UDKey.isLogged.set(newValue)
    }
  }
  
  static var authToken: String {
    get { return UDKey<String>.authToken.value.unwrapped(or: "") }
    set { UDKey.authToken.set(newValue) }
  }
  
  static var authUser: Int {
    get { return UDKey<Int>.authUser.value.unwrapped(or: -1)}
    set { UDKey.authUser.set(newValue) }
  }
  
  static var token: String {
    get { return UDKey<String>.token.value.unwrapped(or: "") }
    set { UDKey.token.set(newValue) }
  }
  
  static var userNiceName: String {
    get { return UDKey<String>.userNiceName.value.unwrapped(or: "") }
    set { UDKey.userNiceName.set(newValue) }
  }
}
