
import Foundation
import CoreText
import Sentry

public final class FontsConfig {
    static public func loadFonts() {
        let fontNames = ["Inter-Regular", "Inter-SemiBold"]
        if let bundle = Bundle(identifier: Theme.bundleId) {
            for fontName in fontNames {
                registerFont(bundle: bundle, fontName: fontName, fontExtension: "ttf")
            }
        }
    }
    
    static private func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
         guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
             SentrySDK.capture(error: ThemeError.couldNotLoadFont(fontName: fontName))
             return
         }

         guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
             SentrySDK.capture(error: ThemeError.couldNotLoadFontFromData(fontName: fontName))
             return
         }

         guard let font = CGFont(fontDataProvider) else {
             SentrySDK.capture(error: ThemeError.couldNotCreateFontFromData(fontName: fontName))
             return
         }
         var error: Unmanaged<CFError>?
         let success = CTFontManagerRegisterGraphicsFont(font, &error)
         guard success else {
             return
         }
         return
     }
}
