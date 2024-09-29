import UIKit

final class TransformationDetailsViewController: UIViewController {

    @IBOutlet weak var transformationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let transformation: Transformation  // The transformation object to display details
    
    // MARK: - Initializer
    init(transformation: Transformation) {
        self.transformation = transformation
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()  // Configure the view with the transformation details
    }

    // MARK: - Configure View with Transformation Data
    private func configureView() {
        // Set the image, name, and description for the selected transformation
        if let url = URL(string: transformation.photo) {
            // Use the setImage(url:) method from the UIImageView extension to load the image
            transformationImageView.setImage(url: url)
        }
        nameLabel.text = transformation.name
        descriptionLabel.text = transformation.description
    }
}
