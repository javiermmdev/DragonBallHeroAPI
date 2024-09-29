import Foundation

struct Hero: Codable, Hashable {
    let description: String
    let name: String
    let favorite: Bool
    let photo: String
    let id: String
}
