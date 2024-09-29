import UIKit

final class CharacterViewController: UICollectionViewController {

    // MARK: - DataSource
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Hero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Hero>

    // MARK: - Properties
    private var heroes: [Hero] = []
    private var dataSource: DataSource?

    // MARK: - Initializer
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 375, height: 150)
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heroes"
        setupCollectionView()
        configureDataSource()
        loadDataConfigureSnapshot()  // Load heroes data

        // Add logout button in the navigation bar
        setupLogoutButton()
    }

    // MARK: - Setup Collection View
    private func setupCollectionView() {
        // Register the custom collection view cell from XIB
        let nib = UINib(nibName: CharacterCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
    }

    // MARK: - Setup Logout Button
    private func setupLogoutButton() {
        // Create logout button with a system image
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle.badge.minus"),
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
        // Set button color to black
        logoutButton.tintColor = .black
        
        // Add the button to the right of the navigation bar
        navigationItem.rightBarButtonItem = logoutButton
    }

    // MARK: - Actions
    @objc private func didTapLogout() {
        // Log out the user and navigate to the login screen
        NetworkModel.shared.logout()
        navigateToLogin()
    }

    // MARK: - Navigate to Login
    private func navigateToLogin() {
        // Obtain the window from SceneDelegate and launch the login view
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            sceneDelegate.launchLoginViewController(in: window)
        }
    }

    // MARK: - DataSource Configuration
    private func configureDataSource() {
        // Setup the diffable data source for the collection view
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, hero) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as? CharacterCollectionViewCell else {
                return UICollectionViewCell()
            }

            // Configure the cell with hero data
            cell.configure(with: hero)

            return cell
        }
    }

    // MARK: - Load Data and Configure Snapshot
    func loadDataConfigureSnapshot() {
        // Fetch heroes from the network model
        NetworkModel.shared.getHeroes { [weak self] result in
            switch result {
            case .success(let heroes):
                DispatchQueue.main.async {
                    // Apply the heroes to the snapshot for the collection view
                    var snapshot = Snapshot()
                    snapshot.appendSections([0])
                    snapshot.appendItems(heroes)
                    self?.dataSource?.apply(snapshot, animatingDifferences: true)
                }
            case .failure(let error):
                print("Error fetching heroes: \(error)")
            }
        }
    }

    // MARK: - Handle Item Selection
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected hero
        if let hero = dataSource?.itemIdentifier(for: indexPath) {
            // Navigate to the detail view of the selected hero
            let detailVC = CharacterDataViewController(hero: hero)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
