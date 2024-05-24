import Foundation
import Alamofire

public typealias APIResponse = (data: Data?, error: Error?, statusCode: Int)
public protocol Requestable {
  associatedtype OutputType: APIOutput
  associatedtype InputType: APIInput
  var input: InputType { get }
  var output: OutputType { get set }
  func excute(with config: APIConfigure,
              and requester: RequesterProviable,
              complete: @escaping (APIResponse) -> Void)
  func getOutput() -> OutputType?
}
extension Requestable {
  public func excute(with config: APIConfigure,
                     and requester: RequesterProviable,
                     complete: @escaping (APIResponse) -> Void) {
    let fullPathToApi = input.makeFullPathToApi(with: config)
    print("DEBUG - URL request: \(fullPathToApi)")
    self.logRequestInfo(with: fullPathToApi)
    if input.getBodyEncode() == .json {
      requester.makeRequest(path: fullPathToApi,
                            requestType: input.requestType,
                            headers: input.makeRequestableHeader(),
                            params: input.makeRequestableBody()) { response in
        self.updateResultForOutput(from: response)
        complete(response)
      }
    } else {
      requester.makeFormDataRequest(path: fullPathToApi,
                                    requestType: input.requestType,
                                    headers: input.makeRequestableHeader(),
                                    params: input.makeRequestableBody()) { response in
        self.updateResultForOutput(from: response)
        complete(response)
      }
    }
  }
}
extension Requestable {
  private func updateResultForOutput(from response: APIResponse) {
    if let data = response.data,
       let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
      NetworkingLogger.write(log: """
              \n----------------------RAW JSON----------------------
              \(json)
              ----------------------********----------------------
              """)
      print("""
              \n----------------------RAW JSON----------------------
              \(json)
              ----------------------********----------------------
              """)
    }

    if hasError(statusCode: response.statusCode) {
      self.output.convertError(from: response.data,
                               systemError: response.error)
    } else if response.error != nil {
      self.output.convertError(from: response.data,
                               systemError: response.error)
    } else {
      self.output.convertData(from: response.data)
    }
  }

  private func hasError(statusCode: Int) -> Bool {
    return (statusCode < 200 || statusCode > 299)
  }

  private func hasSystemError(data: Any?, systemError: Error?) -> Bool {
    if let data = data as? [String: Any], let code = data["code"] as? String {
      return code != "success"
    }
    return systemError != nil
  }

  private func logRequestInfo(with path: String) {
    NetworkingLogger.write(log: "API full api: \(path)", logLevel: .warning)
    NetworkingLogger.write(log: "[\(type(of: self.input))][Type]: HTTP.\(self.input.requestType)", logLevel: .verbose)
    NetworkingLogger.write(log: "[\(type(of: self.input))][Param]: \(self.input.makeRequestableBody())",
                           logLevel: .verbose)
    NetworkingLogger.write(log: "[\(type(of: self.input))][Encode]: \(input.getBodyEncode())",
                           logLevel: .verbose)
  }
}
