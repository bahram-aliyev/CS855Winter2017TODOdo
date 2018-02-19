//
//  FlatGroupping.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-21.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class FlatGrouping : ItemsGroupingStrategy {
    override func groupItems(items: [ToDoItem]) -> [String : [ToDoItem]] {
        var flatGroup = [String : [ToDoItem]]()
        let filteredItems = self.filterStrategy.filterItems(items: items)
        
        flatGroup[GroupingDescriptor.Completed] =
            filteredItems.sorted(by: { (item1, item2) -> Bool in
                return sortByDateDesc(item1.completedDate, item2.completedDate)
            })
        
        return flatGroup
    }
}
