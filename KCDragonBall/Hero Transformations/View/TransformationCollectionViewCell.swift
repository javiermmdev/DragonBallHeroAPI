import UIKit

final class TransformationCollectionViewCell: UICollectionViewCell {

    // MARK: - Identifier
    static let identifier = String(describing: TransformationCollectionViewCell.self)
    
    @IBOutlet weak var transformationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Configuration
    func configure(with transformation: Transformation) {
        // Set the name and description of the transformation
        nameLabel.text = transformation.name
        descriptionLabel.text = transformation.description
        
        // Safely unwrap the image URL, if invalid, return early
        guard let url = URL(string: transformation.photo) else {
            return
        }
        
        // Load the image asynchronously using the setImage method from the UIImageView extension
        transformationImageView.setImage(url: url)
    }
}
