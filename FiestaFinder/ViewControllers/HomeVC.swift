import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeVC: UITableViewController {
    
    var data: [EventModel]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Fetch data from Firestore
        FirebaseActions().fetchEvents(completion: { events, error in
            self.data = events
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell
        cell?.customEventTitle?.text = data?[indexPath.row].name
        downloadImage(imagePath: data?[indexPath.row].locandina ?? "", completion: { locandina in
            cell?.customImageCell?.image = locandina
        })
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetail", sender: data?[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventDetail") {
            let secondView = segue.destination as! EventDetailVC
            let event = sender as? EventModel
            secondView.event = event
        }
    }
}

