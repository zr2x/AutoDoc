//
//  News.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 14.07.2025.
//

import Foundation

struct NewsItems: Codable, Hashable {
    let news: [News]
}

extension NewsItems {
    struct News: Codable, Hashable {
        let id: Int?
        let title: String?
        let description: String?
        let publishedDate: String?
        let url: URL?
        let fullUrl: URL?
        let titleImageUrl: URL?
        let categoryType: String?
    }
}
