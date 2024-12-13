import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Dynamically load API key from environment
    if let path = Bundle.main.path(forResource: ".env", ofType: nil),
       let data = try? String(contentsOfFile: path) {
      let lines = data.components(separatedBy: .newlines)
      for line in lines {
        if line.contains("GOOGLE_MAPS_API_KEY_IOS") {
          let apiKey = line.components(separatedBy: "=")[1].trimmingCharacters(in: .whitespaces)
          GMSServices.provideAPIKey(apiKey)
          break
        }
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}