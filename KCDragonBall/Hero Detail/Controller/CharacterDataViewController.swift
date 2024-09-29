import UIKit

class CharacterDataViewController: UIViewController {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var transformationButton: UIButton!
    
    private let hero: Hero
    private var transformations: [Transformation] = []
    
    // MARK: - Initializer
    init(hero: Hero) {
        self.hero = hero
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        transformationButton.isHidden = true  // Hide transformation button by default
        configureView()  // Configure view with hero data
        getDataTransformation()  // Fetch hero's transformations
        
        // Add action to the transformation button
        transformationButton.addTarget(self, action: #selector(navigateTransformations(_:)), for: .touchUpInside)
    }
    
    // MARK: - Configure View with Hero Data
    private func configureView() {
        // Load hero image if the URL is valid
        if let url = URL(string: hero.photo) {
            characterImageView.setImage(url: url)
        }
        
        nameLabel.text = hero.name
        descriptionLabel.text = hero.description
        transformationButton.setTitle("Transformaciones", for: .normal)
    }
    
    // MARK: - Fetch Hero's Transformations
    private func getDataTransformation() {
        NetworkModel.shared.getTransformations(for: hero) { [weak self] result in
            switch result {
            case .success(let transformations):
                DispatchQueue.main.async {
                    if transformations.isEmpty {
                        // Keep the button hidden if there are no transformations
                        print("No tiene transformaciones")
                    } else {
                        // Store transformations and show the button
                        self?.transformations = transformations
                        self?.transformationButton.isHidden = false
                        print("Tiene transformaciones")
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    // In case of an error, keep the button hidden
                    print("No tiene transformaciones, fallo")
                }
            }
        }
    }

    // MARK: - Navigate to Transformations View
    @IBAction func navigateTransformations(_ sender: UIButton) {
        // Ensure that there are transformations available
        guard !transformations.isEmpty else { return }
        
        // Instantiate TransformationViewController and pass the transformations
        let transformationVC = TransformationViewController(transformations: transformations, characterName: hero.name)
        
        // Navigate to the TransformationViewController
        navigationController?.pushViewController(transformationVC, animated: true)
    }
}
