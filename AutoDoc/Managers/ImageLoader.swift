//
//  ImageLoader.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 14.07.2025.
//

import Foundation

final class ImageLoader {
    static let shared = ImageLoader()
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init () { }
    
    func downloadImage(_ url: URL) async throws -> Data {
        let key = url.absoluteString as NSString
        
        if let cachedData = imageDataCache.object(forKey: key) {
            return cachedData as Data
        }
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let value = data as NSData
        imageDataCache.setObject(value, forKey: key)
        return data
    }
}
