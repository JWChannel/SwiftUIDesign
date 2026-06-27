import Foundation

public struct ParsedCard: Identifiable {
    public let id = UUID()
    public let title: String
    public let items: [ParsedTaskItem]
    public let isExpandable: Bool
    public let collapsedItemLimit: Int

    public init(title: String,
                items: [ParsedTaskItem],
                isExpandable: Bool,
                collapsedItemLimit: Int) {
        self.title = title
        self.items = items
        self.isExpandable = isExpandable
        self.collapsedItemLimit = collapsedItemLimit
    }

    public struct ParsedTaskItem: Identifiable {
        public let id = UUID()
        public let title: String
        public let isDone: Bool
        public let isFlaged: Bool

        public init(title: String, isDone: Bool, isFlaged: Bool) {
            self.title = title
            self.isDone = isDone
            self.isFlaged = isFlaged
        }
    }
}
