public protocol NetworkProvider {
  var observeHeaderStatusCode: ((Int, Error?, Any?) -> Void)? { get set }
  init(with config: APIConfigure, and requester: RequesterProviable?)
  func load<T: Requestable>(api: T,
                               onComplete: @escaping (T) -> Void,
                               onRequestError: @escaping (T) -> Void,
                               onServerError: @escaping (Error?) -> Void)
}

public class DefaultNetworkProvider: NetworkProvider {
  private var config: APIConfigure
  private var requester: RequesterProviable
  public var observeHeaderStatusCode: ((Int, Error?, Any?) -> Void)?
  public required init(with config: APIConfigure,
                       and requester: RequesterProviable? = nil) {
    self.config = config
    self.requester = requester ?? AlamofireRequesterProvider()
    if self.config.debugger.enableLog {
      NetworkingLogger.logWriter = ConsoleLogger()
    } else {
      NetworkingLogger.logWriter = NullLogger()
    }
    
    NetworkingLogger.write(log: """
            \n--------------*****---------------------------------
            Starting Api service
            ||    - API host: \(self.config.host)
            ||    - Requester: \(type(of: self.requester))
            --------------*****---------------------------------
            """)
  }
  public func load<T: Requestable>(api: T,
                                      onComplete: @escaping (T) -> Void,
                                      onRequestError: @escaping (T) -> Void,
                                      onServerError: @escaping (Error?) -> Void) {
    NetworkingLogger.write(log: "API will call: \(type(of: api.input))", logLevel: .warning)
    print("DEBUG - API body: \(api.input.makeRequestableBody())")
    api.excute(with: self.config,
               and: self.requester) { [weak self] _, _, statusCode in
      guard let self = self else { return }
      print("DEBUG - Status code: \(statusCode)")
      if api.output.hasError() {
        // TODOs: refactor this logic
        if api.output.errorServerInfomation != nil {
          onServerError(api.output.errorServerInfomation)
          if api.input.shouldBroadcastStatusCode() {
            self.broadcast(statusCode,
                           request: api.output.errorServerInfomation,
                           api: nil)
          }
        } else {
          self.broadcast(statusCode,
                         request: nil,
                         api: api)
          onRequestError(api)
        }
      } else {
        onComplete(api)
      }
    }
  }
  
  private func broadcast(_ statusCode: Int, request: Error?, api: Any?) {
    if let concreteDelegate = self.observeHeaderStatusCode {
      concreteDelegate(statusCode, request, api)
    }
  }
}
