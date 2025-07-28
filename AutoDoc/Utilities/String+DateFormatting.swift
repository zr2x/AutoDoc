//
//  String+DateFormatting.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 16.07.2025.
//

import Foundation

extension String {
    var dateWithTimeFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: self) else { return self }
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
