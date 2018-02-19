//
//  ItemsFilters.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-21.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActiveOnlyItemsFilter : ItemsFilterStrategy {
    func filterItems(items: [ToDoItem]) -> [ToDoItem] {
        return items.filter { $0.status == .active }
    }
}

class ActiveAndExpiredItemsFilter : ItemsFilterStrategy {
    func filterItems(items: [ToDoItem]) -> [ToDoItem] {
        return items.filter { $0.status == .active || $0.status == .expired };
    }
}

class CompletedOnlyItemsFilter : ItemsFilterStrategy {
    func filterItems(items: [ToDoItem]) -> [ToDoItem] {
        return items.filter { $0.status == .done }
    }
}

class AllItemsFilter : ItemsFilterStrategy {
    func filterItems(items: [ToDoItem]) -> [ToDoItem] {
        return items
    }
}

