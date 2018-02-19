//
//  ActiveOnlyItemsFilter.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActiveOnlyItemsFilter : ItemsFilterStretegy {
    func filterItems(items: [ToDoItem]) -> [ToDoItem] {
        return items.filter { $0.status == .active }
    }
}
