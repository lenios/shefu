import Flutter
import UIKit
import Vision

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "TextRecognitionPlugin") {
      TextRecognitionPlugin.register(with: registrar)
    }
  }
}

/// Text recognition of recipe photos with Apple Vision (lib/utils/ocr.dart):
/// the text as blocks, top to bottom, each a list of lines.
final class TextRecognitionPlugin: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "fr.orvidia.shefu/ocr", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(TextRecognitionPlugin(), channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      result(true)
    case "recognize":
      guard let path = call.arguments as? String, let image = UIImage(contentsOfFile: path),
        let cgImage = image.cgImage
      else {
        result(FlutterError(code: "ocr", message: "Unreadable image", details: nil))
        return
      }
      let orientation = CGImagePropertyOrientation(image.imageOrientation)
      DispatchQueue.global(qos: .userInitiated).async {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        if #available(iOS 16.0, *) {
          request.automaticallyDetectsLanguage = true
        }
        do {
          try VNImageRequestHandler(cgImage: cgImage, orientation: orientation).perform([request])
          let blocks = Self.blocks(request.results ?? [])
          DispatchQueue.main.async { result(blocks) }
        } catch {
          DispatchQueue.main.async {
            result(FlutterError(code: "ocr", message: error.localizedDescription, details: nil))
          }
        }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Lines grouped into blocks: a line continues the block above when it is
  /// close below it (a gap under its own height) and starts at the same place.
  static func blocks(_ observations: [VNRecognizedTextObservation]) -> [[String]] {
    // Vision coordinates are normalized, with the origin at the bottom left.
    let lines = observations.compactMap { observation -> (text: String, box: CGRect)? in
      guard let text = observation.topCandidates(1).first?.string else { return nil }
      return (text, observation.boundingBox)
    }.sorted { $0.box.maxY > $1.box.maxY }

    var blocks: [[String]] = []
    var previous: CGRect?
    for line in lines {
      if let above = previous,
        above.minY - line.box.maxY < line.box.height,
        abs(above.minX - line.box.minX) < 0.1
      {
        blocks[blocks.count - 1].append(line.text)
      } else {
        blocks.append([line.text])
      }
      previous = line.box
    }
    return blocks
  }
}

extension CGImagePropertyOrientation {
  init(_ orientation: UIImage.Orientation) {
    switch orientation {
    case .up: self = .up
    case .upMirrored: self = .upMirrored
    case .down: self = .down
    case .downMirrored: self = .downMirrored
    case .left: self = .left
    case .leftMirrored: self = .leftMirrored
    case .right: self = .right
    case .rightMirrored: self = .rightMirrored
    @unknown default: self = .up
    }
  }
}
