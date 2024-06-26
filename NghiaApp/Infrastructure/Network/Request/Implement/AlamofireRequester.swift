import Alamofire
import Foundation

public protocol RequesterProviable {
  func makeRequest(path: String,
                   requestType: RequestType,
                   headers: [String: String],
                   params: [String: Any],
                   complete: @escaping (APIResponse) -> Void)
  func makeFormDataRequest(path: String,
                           requestType: RequestType,
                           headers: [String: String],
                           params: [String: Any],
                           complete: @escaping (APIResponse) -> Void)
}

public class AlamofireRequesterProvider: RequesterProviable {
  public func makeRequest(path: String,
                          requestType: RequestType,
                          headers: [String: String],
                          params: [String: Any],
                          complete: @escaping (APIResponse) -> Void) {
    AF.request(path,
               method: HTTPMethod(rawValue: requestType.rawValue) ,
               parameters: params,
               encoding: (requestType == .get) ? URLEncoding.default : JSONEncoding.default,
               headers: HTTPHeaders(headers)
    ).responseJSON { (response) in
      complete((response.data, response.error, response.response?.statusCode ?? 200))
    }
  }
  public func makeFormDataRequest(path: String,
                                  requestType: RequestType,
                                  headers: [String: String],
                                  params: [String: Any],
                                  complete: @escaping (APIResponse) -> Void) {
    AF.upload(
      multipartFormData: { formData in
        for param in params {
          if let string = param.value as? String,
             let stringData = string.data(using: .utf8) {
            formData.append(stringData, withName: param.key)
          }
          if let fileData = param.value as? Data {
            formData.append(fileData, withName: param.key, fileName: "upload_image.png")
          }
        }
      },
      to: path,
      method: HTTPMethod(rawValue: requestType.rawValue) ,
      headers: HTTPHeaders(headers)
    ).responseJSON { (response) in
      if let dataConcrete = response.data {
        NetworkingLogger.write(log: "[Error]: \(String(decoding: dataConcrete, as: UTF8.self))",
                               logLevel: .error)
      }
      complete((response.data, response.error, response.response?.statusCode ?? 200))
    }
  }
}
