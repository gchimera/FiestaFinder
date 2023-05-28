import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var userTX: UITextField?
    @IBOutlet weak var psswTX: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTX?.text = UserCredentials.emailAuth
        psswTX?.text = UserCredentials.passwAuth
        
        /// Event reminders
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    @IBAction func signin() {
        FirebaseActions().signIn(email: userTX?.text ?? "", password: psswTX?.text ?? "", viewController: self, completion: { user, error in
            
            if let isLogged = user {
                print(isLogged)
                
                UserCredentials.emailAuth = self.userTX!.text!
                UserCredentials.passwAuth = self.psswTX!.text!
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "homeVC") as! HomeVC
                
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        })
    }
    
}

