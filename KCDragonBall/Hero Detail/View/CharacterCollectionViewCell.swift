import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {

    // MARK: - Identifier
    static let identifier = String(describing: CharacterCollectionViewCell.self)
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heroLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Configuration
    func configure(with hero: Hero) {
        // Set the hero's name and description
        heroLabel.text = hero.name
        descriptionLabel.text = hero.description

        // Safely unwrap the URL for the hero's image
        guard let url = URL(string: hero.photo) else {
            return
        }

        // Load the hero's image asynchronously using the setImage method
        heroImageView.setImage(url: url)
    }
}
