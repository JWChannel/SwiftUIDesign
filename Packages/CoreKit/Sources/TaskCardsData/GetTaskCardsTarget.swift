import Foundation
import Networking

struct GetTaskCardsTarget: TargetType {
    typealias Response = GetTaskCardsResponseModel

    let requestModel: GetTaskCardsRequestModel

    var baseURL: URL { URL(string: "https://example.com")! }
    var path: String { "/api/task-cards" }
    var method: HTTPMethod { .post }

    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "userId", value: requestModel.userId)]
    }

    var sampleData: Data {
        guard let url = Bundle.module.url(forResource: "sampleJSON", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Cannot find sample data")
        }
        return data
    }
}
