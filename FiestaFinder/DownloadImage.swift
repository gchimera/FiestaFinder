import UIKit

func downloadImage(imagePath: String, completion: @escaping (UIImage?) -> Void) {    
    if let url = URL(string: imagePath) {
        // Create a URLSessionDataTask to fetch the image data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // Update the image view on the main queue
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        
        // Start the network request
        task.resume()
    }
}

let defaultImage = "https://www.spanish-fiestas.com/wp-content/uploads/2020/06/mai-fiesta-carnival-02.jpg"
