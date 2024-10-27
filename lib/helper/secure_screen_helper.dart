import 'package:screen_protector/screen_protector.dart';

class SecureScreenHelper {
  static Future<void> secureScreenDataLeakageWithBlur() async => (await ScreenProtector.protectDataLeakageWithBlur());

  static Future<void> secureScreenshot() async => (await ScreenProtector.preventScreenshotOn());

  static Future<void> unsecureScreenDataLeakageWithBlur() async =>
      (await ScreenProtector.protectDataLeakageWithBlurOff());

  static Future<void> unsecureScreenshot() async => (await ScreenProtector.preventScreenshotOff());
}
