
# DragonBallHeroAPI

KCDragonBall is an iOS app built in Swift that allows users to explore Dragon Ball characters and their transformations. The app uses `UICollectionView` to display characters, integrates `JWT` for login authentication, and communicates with a remote API to fetch character data and transformations.

This README is also available in: 
- [Español](docs/es/readme.md)

## Features
- User login with JWT-based authentication.
- Display of characters in a scrollable list.
- View details of a selected character, including their transformations.
- Asynchronous image loading for character profiles.
- Logout functionality with secure token management.
  
## Requirements
- Xcode 12.0 or later.
- iOS 13.0 or later.
- Swift 5.0 or later.
  
## Installation

To set up the project locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/javiermmdev/DragonBallHeroAPI.git
   cd KCDragonBall
   ```

2. Open the project in Xcode:
   ```bash
   open KCDragonBall.xcodeproj
   ```

3. Build and run the app in a simulator or a physical device.

## Project Structure

The project follows the Model-View-Controller (MVC) design pattern, structured as follows:

```
.
├── Models
│   ├── Hero.swift                 # Model representing a Dragon Ball character
│   ├── Transformation.swift       # Model representing character transformations
├── Views
│   ├── CharacterCollectionViewCell.swift   # Collection view cell for characters
│   ├── TransformationCollectionViewCell.swift # Collection view cell for transformations
├── ViewControllers
│   ├── CharacterViewController.swift   # Main view controller displaying characters
│   ├── CharacterDataViewController.swift # Detail view controller for a selected character
│   ├── TransformationViewController.swift  # View controller for displaying transformations
│   ├── loginHeroViewController.swift  # Login screen view controller
├── Network
│   ├── NetworkModel.swift        # Manages network requests and token handling
│   ├── APIClient.swift           # API client for performing HTTP requests
│   ├── APIClientProtocol.swift   # Protocol for API client
│   ├── APIClientProtocolMock.swift  # Mock implementation for testing
├── Tests
│   ├── NetworkModelTests.swift   # Unit tests for NetworkModel
├── Resources
│   ├── Assets.xcassets            # App assets such as images and icons
│   ├── LaunchScreen.storyboard    # Launch screen UI
├── SceneDelegate.swift            # Handles navigation based on login state
└── AppDelegate.swift              # Application delegate
```

## Usage

### 1. **Login**:
Upon launching the app, the user is prompted with a login screen. If valid credentials are entered, the app retrieves a JWT token and stores it securely.

[![Login](https://i.imgur.com/oyKDTIa.png)](https://i.imgur.com/3ScrPfC.png)

If the login fails, an error message is displayed.

[![Login Failed](https://i.imgur.com/GrUr2nM.png)](https://i.imgur.com/XNy3Fi5.png)

### 2. **Characters List**:
After logging in, the app displays a scrollable list of Dragon Ball characters, each with an image and description.

[![Hero Page](https://i.imgur.com/kLLHZoU.png)](https://i.imgur.com/wjtnxqq.png)

### 3. **Character Detail**:
Clicking on a character opens a detail screen that includes their description and, if applicable, their transformations.

#### Hero with No Transformations:
[![Hero with no transformations](https://i.imgur.com/GvyQ2iy.png)](https://i.imgur.com/EmoDkqW.png)

#### Hero with Transformations:
[![Hero with transformations](https://i.imgur.com/cEm8l0H.png)](https://i.imgur.com/LlN1iAv.png)

### 4. **Transformations**:
If the selected hero has transformations, the user can view them on a separate screen.

[![Transformations](https://i.imgur.com/yUsDLti.png)](https://i.imgur.com/FY7pIT6.png)

### 5. **Transformation Details**:
Selecting a transformation from the list allows users to view more details about it.

[![Transformation Details](https://i.imgur.com/SgRfdrE.png)](https://i.imgur.com/xMW6TCU.png)

### 6. **Logout**:
Users can log out by clicking the logout button on the main character screen.

## Running Tests

Unit tests are written using `XCTest`. To run the tests:

1. Open the project in Xcode.
2. Select the `Product` menu and click `Test` (or press `Cmd+U`).
3. Alternatively, run the tests using the Xcode test navigator.

The test suite includes:

- **NetworkModelTests.swift**: Verifies the behavior of network requests, including login functionality, fetching heroes, and handling network errors. Mock objects are used to simulate API responses without making actual network calls.

## API Endpoints

The app communicates with the following API endpoints:

- **Login**: `/api/auth/login` (POST)
- **Get Heroes**: `/api/heros/all` (POST)
- **Get Transformations**: `/api/heros/tranformations` (POST)

Each request is authenticated using a Bearer token obtained during the login process.

## Technologies Used

- **Swift 5**
- **UIKit**: For building the user interface.
- **URLSession**: To perform network requests.
- **XCTest**: For unit testing.
- **UserDefaults**: For persisting login credentials securely.
- **Diffable Data Source**: For efficient `UICollectionView` updates.

## Testing Strategy

To ensure the reliability of the networking layer and the app's state management, the following testing approach is used:

- **Mocking the Network Layer**: `APIClientProtocolMock` is used to simulate network responses in tests.
- **Unit Tests**: Tests verify the login flow, token validation, and fetching of character data, ensuring the app handles success and failure cases correctly.
- **Edge Cases**: Tests include handling of missing tokens, malformed URLs, and network failures.

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature-branch`.
3. Commit your changes: `git commit -m 'Add new feature'`.
4. Push to the branch: `git push origin feature-branch`.
5. Submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
