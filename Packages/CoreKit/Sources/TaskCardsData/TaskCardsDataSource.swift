import Foundation
import Networking
import TaskCardsDomain

public final class TaskCardsDataSource: TaskCardsDataSourceProtocol {
    private let client: NetworkClientProtocol

    public init(client: NetworkClientProtocol = NetworkClient(useStub: true)) {
        self.client = client
    }

    public func getTaskCards(userId: String) async throws -> [ParsedCard] {
        let target = GetTaskCardsTarget(requestModel: GetTaskCardsRequestModel(userId: userId))
        let response = try await client.request(target)
        return TaskCardsParser.parse(response.data ?? [])
    }
}
