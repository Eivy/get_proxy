import Flutter
import UIKit

public class SwiftGetProxyPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "get_proxy", binaryMessenger: registrar.messenger())
    let instance = SwiftGetProxyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "getProxyAddress":
        let url = (call.arguments as! [String: Any])["url"] as! String
        result(getProxyAddress(url: url))
    case "getProxyType":
        let url = (call.arguments as! [String: Any])["url"] as! String
        result(getProxyType(url: url))
    default:
        result(FlutterMethodNotImplemented)
    }
  }

  private func getProxyAddress(url: String) -> String {
    if let url = URL(string: url) {
      let systemProxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() ?? [:] as CFDictionary
      let proxy = (CFNetworkCopyProxiesForURL(url as CFURL, systemProxySettings).takeUnretainedValue() as? [[AnyHashable: Any]] ?? [])[0]
      print("Proxy: \(String(describing: proxy))")
      return (proxy[kCFProxyHostNameKey] as? String ?? "")+":"+String((proxy[kCFProxyPortNumberKey] as? Int ?? 0))
    }
    return ""
  }

  private func getProxyType(url: String) -> String {
    if let url = URL(string: "https://someurloutthere.com") {
      let systemProxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() ?? [:] as CFDictionary
      let proxiesForTargetUrl = CFNetworkCopyProxiesForURL(url as CFURL, systemProxySettings).takeUnretainedValue() as? [[AnyHashable: Any]] ?? []
        switch proxiesForTargetUrl[0][kCFProxyTypeKey] as! CFString {
        case kCFProxyTypeFTP:
            return "FTP"
        case kCFProxyTypeHTTP:
            return "HTTP"
        case kCFProxyTypeHTTPS:
            return "HTTPS"
        case kCFProxyTypeSOCKS:
            return "SOCKS"
        case kCFProxyTypeAutoConfigurationURL:
            return "PAC"
        case kCFProxyTypeAutoConfigurationJavaScript:
            return "PAC_JS"
        default:
            return "DIRECT"
        }
    }
    return "DIRECT"
  }

}
