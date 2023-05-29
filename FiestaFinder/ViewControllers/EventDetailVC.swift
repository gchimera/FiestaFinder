import UIKit
import MapKit

class EventDetailVC: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var soldout: UIBarButtonItem!
    
    @IBOutlet weak var location: MKMapView! {
        didSet {
            if missedCoordinates() {
                location.isHidden = true
            } else {
                addAnnotationAtSpecificLocation()
            }
        }
    }
    
    var event: EventModel? {
        didSet {
            if !event!.soldout {
                soldout.isHidden = true
            }
        }
    }
    
    var notificationString = "🔔 Set a reminder in 20 seconds"
    var notificationScheduled = false {
        didSet {
            if notificationScheduled {
                notificationString = "Notification scheduled. Move the app to background and wait 20 seconds"
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = event?.name
        
        downloadImage(imagePath: event?.locandina ?? defaultImage) { locandina in
            self.imageView.image = locandina
        }
    }
}

// MARK: - Table view data source
extension EventDetailVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missedCoordinates() ? 4 : 5 /// ternary operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.textColor = .gray
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = "About the event"
            cell.textLabel?.text = event?.description
        case 1:
            cell.detailTextLabel?.text = "Date"
            cell.textLabel?.text = event?.data
        case 2:
            cell.detailTextLabel?.text = "Price"
            cell.textLabel?.text = event?.prezzo.description
        case 3:
            cell.detailTextLabel?.text = notificationString
            cell.textLabel?.text = "Reminder"
        case 4:
            cell.textLabel?.text = "latidute: \(event!.latitude) - longitude: \(event!.longitude)"
            cell.detailTextLabel?.text = "🗺️ Tap here to open the current coordinates from Map app"
        default: break
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            scheduleNotificationButtonTapped()
            notificationScheduled = true
        } else if indexPath.row == 4 {
            let coordinate = CLLocationCoordinate2D(latitude: event?.latitude ?? 0.0, longitude: event?.longitude ?? 0.0)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = event?.name
            
            mapItem.openInMaps()
        }
    }
    
}


extension EventDetailVC {
    
    func missedCoordinates() -> Bool {
        if event?.latitude == 0.0 || event?.longitude == 0.0 {
            return true
        } else {
            return false
        }
    }
    
    func addAnnotationAtSpecificLocation() {
        location.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 90000, // Minimum zoom value
            maxCenterCoordinateDistance: 90000) // Max zoom value
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: event?.latitude ?? 0.0, longitude: event?.longitude ?? 0.0) // Specify the desired latitude and longitude
        
        location.addAnnotation(annotation)
        
        // Optionally, you can set the region to show the annotation on the map
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000) // Adjust the region span as needed
        location.setRegion(region, animated: true)
    }
    
    func scheduleNotificationButtonTapped() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder for"
        content.body = event?.name ?? "Unknown"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        
        let request = UNNotificationRequest(identifier: event?.name ?? randomString(length: 10), content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charCount = UInt32(characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(charCount))
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }
        
        return randomString
    }
    
}
