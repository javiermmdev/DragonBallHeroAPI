import UIKit

private let reuseIdentifier = TransformationCollectionViewCell.identifier

final class TransformationViewController: UICollectionViewController {
    
    // MARK: - DataSource
    // Typealiases to simplify the reference to the DataSource and Snapshot types
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Transformation>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Transformation>
    
    // MARK: - Properties
    private var transformations: [Transformation]
    private var characterName: String
    private var dataSource: DataSource?
    
    // MARK: - Initializer
    init(transformations: [Transformation], characterName: String) {
        self.transformations = transformations
        self.characterName = characterName

        // Set up the layout for the collection view with vertical scrolling
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 375, height: 150)
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transformaciones"
        
        // Register the custom collection view cell
        collectionView.register(UINib(nibName: TransformationCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Setup the data source and load initial data
        configureDataSource()
        configureSnapshot()
        
        // Configure the custom back button in the navigation bar
        setupBackButton()
    }
    
    // MARK: - DataSource Configuration
    private func configureDataSource() {
        // Setup the diffable data source, binding each transformation to a cell
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, transformation) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TransformationCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            // Pass the transformation data to the cell
            cell.configure(with: transformation)
            
            return cell
        }
    }
    
    // MARK: - Snapshot Configuration
    private func configureSnapshot() {
        // Create a snapshot with the transformation data and apply it to the data source
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(transformations)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Back Button Setup
    private func setupBackButton() {
        // Create a custom button with an image and the character name for the back button
        let backButtonView = UIButton(type: .system)

        backButtonView.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButtonView.setTitle(characterName, for: .normal)
        backButtonView.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        // Add an action to handle the back navigation
        backButtonView.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Set the button as the left bar button item
        let backButtonItem = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    // MARK: - Back Button Action
    @objc private func backButtonTapped() {
        // Pop the current view controller, navigating back to the previous one
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Handle Cell Selection
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected transformation and navigate to the details view controller
        guard let selectedTransformation = dataSource?.itemIdentifier(for: indexPath) else { return }
   
        let detailsVC = TransformationDetailsViewController(transformation: selectedTransformation)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
