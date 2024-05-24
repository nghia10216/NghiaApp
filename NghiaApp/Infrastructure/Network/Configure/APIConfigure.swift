public struct DebuggerConfig {
  var enableLog: Bool = false
  public static let none = DebuggerConfig(enableLog: false)
  public static let full = DebuggerConfig(enableLog: true)
}
public protocol APIConfigure {
  var host: String { get set }
  var debugger: DebuggerConfig { get set }
}
