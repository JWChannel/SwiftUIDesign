import Foundation

struct GetTaskCardsResponseModel: Decodable {
    let success: Bool?
    let resultMessage: String?
    let data: [Card]?
}

extension GetTaskCardsResponseModel {
    struct Card: Decodable {
        let title: String?
        let items: [TaskItem]?
    }
}

extension GetTaskCardsResponseModel.Card {
    struct TaskItem: Decodable {
        let title: String?
        let isDone: Bool?
        let isFlaged: Bool?
    }
}
