//
//  GroupingBase.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-21.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ItemsGroupingStrategy {
    
    private(set) var filterStrategy: ItemsFilterStrategy
    
    required init(filterStrategy: ItemsFilterStrategy) {
        self.filterStrategy = filterStrategy
    }
    
    func groupItems(items: [ToDoItem]) -> [String : [ToDoItem]] {
            preconditionFailure("This method must be overridden")
    }
    
    final func sortByDateDesc(_ date1: Date?, _ date2: Date?) -> Bool {
        return
            date1 == nil
                ? (date2 == nil ? false : true)
                : (date2 != nil ? date1! > date2! : false)
    }
}
