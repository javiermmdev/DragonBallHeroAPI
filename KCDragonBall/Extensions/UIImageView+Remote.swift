import UIKit

extension UIImageView {
    func setImage(url: URL) {
        // Using [weak self] to prevent retain cycles that could lead to memory leaks
        downloadWithURLSession(url: url) { [weak self] image in
            DispatchQueue.main.async {
                // Ensuring the image assignment happens on the main thread as it's a UI update
                self?.image = image
            }
        }
    }
    
    // Downloads an image from the given URL using URLSession
    // Calls the completion handler with the image once the download is complete
    private func downloadWithURLSession(
        url: URL,
        completion: @escaping (UIImage?) -> Void
    ) {
        // Error handling is omitted for simplicity
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            // Ensure that data is not nil and that we can create a UIImage
            guard let data, let image = UIImage(data: data) else {
                // If either the data or image can't be unwrapped, pass nil to the completion handler
                completion(nil)
                return
            }
            completion(image)
        }
        .resume()
    }
}
