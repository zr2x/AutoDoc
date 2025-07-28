//
//  Collection+Extension.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 15.07.2025.
//

import Foundation

extension Collection {
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func notContains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains(where: predicate)
    }
}
