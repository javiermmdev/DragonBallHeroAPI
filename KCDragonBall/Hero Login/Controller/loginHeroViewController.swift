import UIKit

class loginHeroViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var photoLogoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the UI components for the login screen
        setupUI()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        // Configure placeholders for the text fields
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true

        // Set background color for text fields
        let lightGrayColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        usernameTextField.backgroundColor = lightGrayColor
        passwordTextField.backgroundColor = lightGrayColor
        
        // Configure the sign-in button
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        
        // Assign an image to the logo image view
        photoLogoImageView.image = UIImage(named: "photoLogin")
    }
    
    // MARK: - Sign In Action
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        // Retrieve text field values and ensure they are not empty
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter a valid username and password.")
            return
        }
        
        // Call the login function from NetworkModel
        NetworkModel.shared.login(user: username, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    // Navigate to the next view on successful login
                    self.navigateToNextViewController()
                } else {
                    // Show alert if login fails
                    self.showAlert(message: "Incorrect login. Invalid credentials.")
                }
            }
        }
    }
    
    // MARK: - Navigation
    func navigateToNextViewController() {
        let characterViewController = CharacterViewController()
        
        // Navigate to CharacterViewController using the UINavigationController
        navigationController?.pushViewController(characterViewController, animated: true)
        
        // Remove loginHeroViewController from the navigation stack
        if var viewControllers = navigationController?.viewControllers {
            // Remove the previous controller (login) from the stack
            viewControllers.remove(at: viewControllers.count - 2)
            navigationController?.viewControllers = viewControllers
        }
    }
    
    // MARK: - Show Alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
