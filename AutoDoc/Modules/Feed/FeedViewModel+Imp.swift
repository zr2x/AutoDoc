//
//  FeedViewModel.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 14.07.2025.
//

import Foundation
import Combine

protocol FeedViewModelProtocol: AnyObject {
    var itemsPublisher: AnyPublisher<[NewsItems.News], Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    func loadNextPage()
}

final class FeedViewModelImpl: FeedViewModelProtocol {

    private var currentPage = 1
    private let pageSize = 15
    private var canLoadMore = true
    private let networkService: NetworkServiceProtocol = AsyncNetworkService.shared

    private var items: [NewsItems.News] = []
    private var isLoading: Bool = false

    private let itemsSubject: PassthroughSubject<[NewsItems.News], Never> = PassthroughSubject()
    private let isLoadingSubject: PassthroughSubject<Bool, Never> = PassthroughSubject()
    private let errorSubject: PassthroughSubject<Error?, Never> = PassthroughSubject()

    var itemsPublisher: AnyPublisher<[NewsItems.News], Never> { itemsSubject.eraseToAnyPublisher() }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { isLoadingSubject.eraseToAnyPublisher() }
    var errorPublisher: AnyPublisher<Error?, Never> { errorSubject.eraseToAnyPublisher() }

    func loadNextPage() {
        guard !isLoading, canLoadMore else { return }

        isLoading = true
        isLoadingSubject.send(isLoading)
        errorSubject.send(nil)
        
        let request = RequestService(endpoint: .news, pathComponents: ["/\(currentPage)", "/\(pageSize)"])

        Task {
            defer {
                isLoading = false
                isLoadingSubject.send(isLoading)
            }
            do {
                let response: NewsItems = try await networkService.execute(request, expecting: NewsItems.self)
                
                if response.news.count < pageSize {
                    canLoadMore = false
                }
                
                items.append(contentsOf: response.news)
                itemsSubject.send(items)
                
                isLoadingSubject.send(isLoading)
                currentPage += 1
            }
            catch {
                errorSubject.send(error)
            }
        }
    }
}
