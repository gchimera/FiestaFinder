import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var userTX: UITextField?
    @IBOutlet weak var psswTX: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTX?.text = UserCredentials.emailAuth
        psswTX?.text = UserCredentials.passwAuth
        
        /// autoclose  keyboard when tap outside textfield
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
         view.addGestureRecognizer(tapGesture)
        
        /// Event reminders
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    @objc func handleTap() {
           view.endEditing(true)
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

