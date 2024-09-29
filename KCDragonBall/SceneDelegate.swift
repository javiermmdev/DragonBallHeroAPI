import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - Scene lifecycle
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)

        // Check if there is an authToken saved in UserDefaults
        if NetworkModel.shared.getAuthToken() != nil {
            // Validate the token if it exists
            NetworkModel.shared.validateToken { isValid in
                DispatchQueue.main.async {
                    if isValid {
                        // If the token is valid, launch the CharacterViewController
                        self.launchCharacterViewController(in: window)
                    } else {
                        // If the token is invalid, log out and show the login screen
                        NetworkModel.shared.logout()
                        self.launchLoginViewController(in: window)
                    }
                }
            }
        } else {
            // If no token exists, launch the login screen
            launchLoginViewController(in: window)
        }

        window.makeKeyAndVisible()
        self.window = window
    }

    // MARK: - Launch login screen
    func launchLoginViewController(in window: UIWindow) {
        let loginViewController = loginHeroViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        window.rootViewController = navigationController
    }

    // MARK: - Launch main character screen
    func launchCharacterViewController(in window: UIWindow) {
        let characterViewController = CharacterViewController()
        let navigationController = UINavigationController(rootViewController: characterViewController)
        window.rootViewController = navigationController
    }
}
