//
//  AsyncNetworkService.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 14.07.2025.
//

import Foundation
import Combine

enum NetworkError: Error {
    case failedToGetData
    case failedToCreateRequest
    case invalidURL
}

protocol NetworkServiceProtocol {
    func execute<T: Codable>(_ request: RequestService, expecting type: T.Type) async throws -> T
}

final class AsyncNetworkService: NetworkServiceProtocol {
    static let shared = AsyncNetworkService()
    private let cacheManager: CacheManagerProtocol = CacheManager()
    private init () { }
    
    public func execute<T: Codable>(_ request: RequestService, expecting type: T.Type) async throws -> T {
        if let cachedData = cacheManager.cacheResponse(
            for: request.endpoint,
            url: request.url
        ) {
            return try JSONDecoder().decode(T.self, from: cachedData)
        }
        
        guard let urlRequest = self.request(from: request) else {
            throw NetworkError.failedToCreateRequest
        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func request(from request: RequestService) -> URLRequest? {
        guard let url = request.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        return request
    }
}
