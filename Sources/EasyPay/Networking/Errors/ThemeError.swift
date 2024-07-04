
import Foundation

enum ThemeError: Error {
    case couldNotLoadFont(fontName: String)
    case couldNotLoadFontFromData(fontName: String)
    case couldNotCreateFontFromData(fontName: String)

}

extension ThemeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .couldNotLoadFont(let fontName):
            return "Could not load font: \(fontName)"
        case .couldNotLoadFontFromData(let fontName):
            return "Couldn't load data from the font: \(fontName)"
        case .couldNotCreateFontFromData(let fontName):
            return "Couldn't create font from data: \(fontName)"
        }
    }
}
