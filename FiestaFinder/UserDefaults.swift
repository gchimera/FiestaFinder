import Foundation

struct UserCredentials {
    static let emailAuthkey = "emailAuth"
    static let psswAuthkey = "passwAuth"
    
    static var emailAuth: String {
        get {
            return UserDefaults.standard.string(forKey: emailAuthkey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailAuthkey)
        }
    }
    
    static var passwAuth: String {
        get {
            return UserDefaults.standard.string(forKey: psswAuthkey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: psswAuthkey)
        }
    }
    
    
}
