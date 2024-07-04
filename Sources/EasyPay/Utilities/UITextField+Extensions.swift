import UIKit

extension UITextField {
    func showOnlyLastDigits(numberOfVisibleLastDigits: Int) {
        guard let text = self.text?.replacingOccurrences(of: " ", with: "") else { return }

        let visibleText = String(text.suffix(numberOfVisibleLastDigits))
        let lengthToHide = max(0, text.count - numberOfVisibleLastDigits)
        let hiddenTextRange = text.startIndex..<text.index(text.startIndex, offsetBy: lengthToHide)
        let hiddenText = text[hiddenTextRange].replacingOccurrences(of: "[0-9]", with: "*", options: .regularExpression, range: hiddenTextRange)

        let combinedText = hiddenText + visibleText
        var formattedText = ""
        for (index, character) in combinedText.enumerated() {
            if index > 0 && index % 4 == 0 {
                formattedText.append(" ")
            }
            formattedText.append(character)
        }

        self.text = formattedText
    }
}
