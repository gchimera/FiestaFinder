import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

struct FirebaseActions {
    
    func signIn(email: String, password: String, viewController: UIViewController? = nil, completion: @escaping (FirebaseAuth.User?, Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as? NSError {
                print("Login error")
                completion(nil, error)
                viewController?.showPopup(isSuccess: false, messsage: "Error authentication")
            } else {
                print("User signs up successfully")
                let newUserInfo = Auth.auth().currentUser
                completion(newUserInfo, nil)
                viewController?.showPopup(isSuccess: true, messsage: "User signs up successfully")
            }
        }
    }
    
    func fetchEvents(completion: @escaping ([EventModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let eventCollection = db.collection("Event")
        
        eventCollection.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var events: [EventModel] = []
            
            for document in snapshot!.documents {
                
                let title = document["name"] as? String ?? ""
                let data = document["data"] as? String ?? ""
                let description = document["description"] as? String ?? ""
                let prezzo = document["prezzo"] as? Double ?? 0.0
                let soldout = document["soldout"] as? Bool ?? false
                let locandina = document["locandina"] as? String ?? ""
                let latitude = document["latitude"] as? Double ?? 0.0
                let longitude = document["longitude"] as? Double ?? 0.0
                
                let ev = EventModel(
                    name: title,
                    data: data,
                    description: description,
                    prezzo: prezzo,
                    soldout: soldout,
                    locandina: locandina,
                    latitude: latitude,
                    longitude: longitude
                )
                events.append(ev)
                
            }
            
            completion(events, nil)
        }
    }
    
    
}
