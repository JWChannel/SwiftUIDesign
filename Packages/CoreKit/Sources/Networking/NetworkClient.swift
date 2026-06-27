import Foundation

public protocol NetworkClientProtocol {
    func request<T: TargetType>(_ target: T) async throws -> T.Response
}

public final class NetworkClient: NetworkClientProtocol {
    private let useStub: Bool
    private let decoder: JSONDecoder

    public init(useStub: Bool = true, decoder: JSONDecoder = JSONDecoder()) {
        self.useStub = useStub
        self.decoder = decoder
    }

    public func request<T: TargetType>(_ target: T) async throws -> T.Response {
        let data = useStub ? target.sampleData : try await send(target)
        return try decoder.decode(T.Response.self, from: data)
    }

    private func send<T: TargetType>(_ target: T) async throws -> Data {
        var components = URLComponents(
            url: target.baseURL.appendingPathComponent(target.path),
            resolvingAgainstBaseURL: false
        )
        if !target.queryItems.isEmpty {
            components?.queryItems = target.queryItems
        }
        guard let url = components?.url else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
