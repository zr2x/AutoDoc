//
//  DataSource+SafeAppending.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 15.07.2025.
//

import Foundation
import UIKit

extension NSDiffableDataSourceSnapshot where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    mutating func safelyAppendItems(_ items: [ItemIdentifierType], toSection section: SectionIdentifierType? = nil) {
        let uniqueItems = items.removingDuplicates()
        appendItems(uniqueItems, toSection: section)
    }
    
    mutating func safelyAppendSections(_ sections: [SectionIdentifierType]) {
        let uniqueSections = sections.removingDuplicates()
        appendSections(uniqueSections)
    }
}
