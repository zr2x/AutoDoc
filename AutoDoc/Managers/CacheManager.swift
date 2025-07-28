//
//  CacheManager.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 14.07.2025.
//

import Foundation

protocol CacheManagerProtocol: AnyObject {
    func cacheResponse(for endpoint: AutoDocEndpoint, url: URL?) -> Data?
    func setCache(for endpoint: AutoDocEndpoint, url: URL?, data: Data)
}

/// Manages in memory session scoped API caches
final class CacheManager: CacheManagerProtocol {
    
    private var cacheDictionary: [AutoDocEndpoint: NSCache<NSString, NSData>] = [:]
    
    init() {
        setupCache()
    }
    
    public func cacheResponse(for endpoint: AutoDocEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint],
              let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: AutoDocEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint],
              let url = url else {
            return
        }
        let key = url.absoluteString as NSString
        return targetCache.setObject(data as NSData, forKey: key)
    }
    
    private func setupCache() {
        AutoDocEndpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
}
