
import Foundation

extension Locale {
    static var actual: Locale {
        let systemLanguage = Locale.preferredLanguages.first ?? "en"
        let locale = Locale(identifier: systemLanguage)
        return locale
    }
}
