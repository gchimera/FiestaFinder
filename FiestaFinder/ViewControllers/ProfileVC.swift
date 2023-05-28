import UIKit
import FirebaseAuth

class ProfileVC: UITableViewController {
    var logout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        var cell: UITableViewCell?
        
        switch indexPath.row {
        case 0:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "intro")
            cell?.textLabel?.textColor = .systemRed
            cell?.textLabel?.text = "User profile details stored on Firebase"
        case 1:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "detailCell")
            cell?.detailTextLabel?.textColor = .gray
            cell?.textLabel?.text = "Your current email"
            cell?.detailTextLabel?.text = UserCredentials.emailAuth
        case 2:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "detailCell")
            cell?.detailTextLabel?.textColor = .gray
            cell?.textLabel?.text = "Email verified"
            cell?.detailTextLabel?.text = Auth.auth().currentUser?.isEmailVerified.description
        case 3:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "detailCell")
            cell?.detailTextLabel?.textColor = .gray
            cell?.textLabel?.text = "Your firebase UID"
            cell?.detailTextLabel?.text = Auth.auth().currentUser?.uid
        case 4:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "detailCell")
            cell?.detailTextLabel?.textColor = .gray
            cell?.textLabel?.text = "Your current token"
            cell?.detailTextLabel?.text = Auth.auth().currentUser?.refreshToken
        default:
            if !logout {
                cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)
            } else {
                cell = self.tableView.dequeueReusableCell(withIdentifier: "intro")
                cell?.textLabel?.textColor = .red
                cell?.textLabel?.text = "Loggin out in few seconds..."
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.dismiss(animated: true)
                }
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    @IBAction func signOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            logout = true
            print("User signed out successfully.")
            UserCredentials.emailAuth = ""
            UserCredentials.passwAuth = ""
            self.tableView.reloadData()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
            self.showPopup(isSuccess: false, messsage: "Error signout")
        }
    }
}
