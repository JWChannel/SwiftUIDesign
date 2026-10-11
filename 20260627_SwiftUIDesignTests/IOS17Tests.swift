//
//  IOS17Tests.swift
//  20260627_SwiftUIDesignTests
//

import Foundation
import Testing
@testable import _0260627_SwiftUIDesignPreviews

@MainActor
struct IOS17Tests {

    // MARK: - PreviewData

    @Test("Preview parent view model has cards after loading")
    func previewParentViewModelLoadsCards() async throws {
        let viewModel = IOS17PreviewData.parentViewModel(.success(PreviewSampleData.cards))
        await viewModel.load()

        let cards = try #require(loadedCards(of: viewModel))
        #expect(cards.isEmpty == false)
    }

    @Test("Preview loaded cards are not empty")
    func previewLoadedCardsIsNotEmpty() async {
        let cards = await IOS17PreviewData.loadedCards(.success(PreviewSampleData.cards))

        #expect(cards.isEmpty == false)
    }

    // MARK: - Loading

    @Test("A failed load shows an empty list")
    func loadFailureShowsEmptyList() async throws {
        let viewModel = IOS17PreviewData.parentViewModel(.failure(URLError(.badServerResponse)))
        await viewModel.load()

        let cards = try #require(loadedCards(of: viewModel))
        #expect(cards.isEmpty)
    }

    // MARK: - Child → Parent actions

    @Test("Toggling done changes only that item")
    func toggleItemDone() async throws {
        let (viewModel, card) = try await loadedFirstCard()
        let target = try #require(card.visibleItems.first { $0.isDone == false })
        let othersBefore = card.visibleItems.filter { $0.id != target.id }.map(\.isDone)

        viewModel.handle(.toggleItemDone(id: card.id, itemID: target.id))

        #expect(card.visibleItems.first { $0.id == target.id }?.isDone == true)
        #expect(card.visibleItems.filter { $0.id != target.id }.map(\.isDone) == othersBefore)
    }

    @Test("Toggling the flag changes only that item")
    func toggleItemFlag() async throws {
        let (viewModel, card) = try await loadedFirstCard()
        let target = try #require(card.visibleItems.first { $0.isFlaged == false })

        viewModel.handle(.toggleItemFlag(id: card.id, itemID: target.id))

        #expect(card.visibleItems.first { $0.id == target.id }?.isFlaged == true)
    }

    @Test("Expanding shows all items and collapsing returns to the limit")
    func toggleExpanded() async throws {
        let (viewModel, card) = try await loadedFirstCard()
        #expect(card.isExpanded == false)
        #expect(card.visibleItems.count == 2)

        viewModel.handle(.toggleExpanded(id: card.id))
        #expect(card.isExpanded == true)
        #expect(card.visibleItems.count == 4)

        viewModel.handle(.toggleExpanded(id: card.id))
        #expect(card.visibleItems.count == 2)
    }

    @Test("A non-expandable card has no expanded state and ignores the toggle")
    func nonExpandableCardIgnoresToggle() async throws {
        let cards = await IOS17PreviewData.loadedCards(.success(PreviewSampleData.cards))
        let viewModel = IOS17PreviewData.parentViewModel(.success(PreviewSampleData.cards))
        await viewModel.load()
        let card = try #require(loadedCards(of: viewModel)?.last)
        #expect(cards.last?.isExpanded == nil)

        viewModel.handle(.toggleExpanded(id: card.id))

        #expect(card.isExpanded == nil)
        #expect(card.visibleItems.count == 2)
    }

    @Test("An action with an unknown id changes nothing")
    func unknownIDIsIgnored() async throws {
        let (viewModel, card) = try await loadedFirstCard()

        viewModel.handle(.toggleExpanded(id: UUID()))

        #expect(card.isExpanded == false)
    }

    // MARK: - Helpers

    private func loadedCards(of viewModel: IOS17ParentViewModel) -> [IOS17ChildViewModel]? {
        guard case let .loaded(cards) = viewModel.state else { return nil }
        return cards
    }

    private func loadedFirstCard() async throws -> (IOS17ParentViewModel, IOS17ChildViewModel) {
        let viewModel = IOS17PreviewData.parentViewModel(.success(PreviewSampleData.cards))
        await viewModel.load()
        let card = try #require(loadedCards(of: viewModel)?.first)
        return (viewModel, card)
    }
}
