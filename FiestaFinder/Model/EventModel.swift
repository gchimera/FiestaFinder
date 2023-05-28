import Foundation
import FirebaseFirestore

struct EventModel: Codable {
    let name: String
    let data: String
    let description: String
    let prezzo: Double
    let soldout: Bool
    let locandina: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case name
        case data
        case description
        case prezzo
        case soldout
        case locandina
        case latitude
        case longitude
    }

    init(name: String, data: String, description: String, prezzo: Double, soldout: Bool, locandina: String, latitude: Double, longitude: Double) {
        self.name = name
        self.data = data
        self.description = description
        self.prezzo = prezzo
        self.soldout = soldout
        self.locandina = locandina
        self.latitude = latitude
        self.longitude = longitude
    }
}

