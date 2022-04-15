import Flutter
import UIKit

public class SwiftBadgeManagerPlugin: NSObject, FlutterPlugin {
    static var enable: Bool = true
    public static func register(with registrar: FlutterPluginRegistrar) {
        enableNotificationPermission();
        let channel = FlutterMethodChannel(name: "badge_manager", binaryMessenger: registrar.messenger())
        let instance = SwiftBadgeManagerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftBadgeManagerPlugin.enableNotificationPermission();
        if call.method == "isSupported" {
            result(SwiftBadgeManagerPlugin.enable)
        } else if call.method == "getBrand" {
            result(getBrand())
        } else if call.method == "setBadge" {
            if SwiftBadgeManagerPlugin.enable {
                let map = call.arguments as! [String:Any];
                let count = map["count"] as! Int
                print(count)
                UIApplication.shared.applicationIconBadgeNumber = count
            }
        } else if call.method == "removeBadge" {
            UIApplication.shared.applicationIconBadgeNumber = 0
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    /// 获取通知权限
    /// - Returns: void
    static func enableNotificationPermission() -> Void {
        if #available(iOS 10.0, *) {
            let authorizationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions) { granted, error in
                enable = granted
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    /// 获取手机型号
    /// - Returns: 手机型号
    func getBrand() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        switch platform {
        //MARK: iPod
        case "iPod1,1":
            return "iPod Touch 1"
        case "iPod2,1":
            return "iPod Touch 2"
        case "iPod3,1":
            return "iPod Touch 3"
        case "iPod4,1":
            return "iPod Touch 4"
        case "iPod5,1":
            return "iPod Touch (5 Gen)"
        case "iPod7,1":
            return "iPod Touch 6"
        //MARK: iPhone
        case "iPhone5,1":
            return "iPhone 5"
        case "iPhone5,2":
            return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":
            return "iPhone 5c (GSM)"
        case "iPhone5,4":
            return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":
            return "iPhone 5s (GSM)"
        case "iPhone6,2":
            return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
        case "iPhone8,4":
            return "iPhone SE"
        case "iPhone9,1":
            return "国行、日版、港行 iPhone 7"
        case "iPhone9,2":
            return "港行、国行 iPhone 7 Plus"
        case "iPhone9,3":
            return "美版、台版 iPhone 7"
        case "iPhone9,4":
            return "美版、台版 iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2","iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":
            return "iPhone X"
        case "iPhone11,8":
            return "iPhone XR"
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,6":
            return "iPhone XS Max"
        case "iPhone11,4":
            return "iPhone XS Max (China)"
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"
        case "iPhone13,1":
            return "iPhone 12 mini"
        case "iPhone13,2":
            return "iPhone 12"
        case "iPhone13,3":
            return "iPhone 12 Pro"
        case "iPhone13,4":
            return "iPhone 12 Pro Max"
        case "iPhone14,4":
            return "iPhone 13 mini"
        case "iPhone14,5":
            return "iPhone 13"
        case "iPhone14,2":
            return "iPhone 13 Pro"
        case "iPhone14,3":
            return "iPhone 13 Pro Max"
        //MARK: iPad
        case "iPad1,1":
            return "iPad"
        case "iPad1,2":
            return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"
        case "iPad6,3", "iPad6,4":
            return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":
            return "iPad Pro 12.9"
        //MARK: AppleTV
        case "AppleTV2,1":
            return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":
            return "Apple TV 3"
        case "AppleTV5,3":
            return "Apple TV 4"
        case "i386", "x86_64":
            return "Simulator"
        default:
            return platform
        }
    }
}

