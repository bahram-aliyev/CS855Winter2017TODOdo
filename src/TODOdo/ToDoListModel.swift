//
//  TodoList.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ToDoListModel {
    
    private var items: [ToDoItem]!
    
    private(set) var groupedItems: [String:[ToDoItem]]!
    private(set) var groups: [String]!
    
    private(set) var filter = ItemsFilter.All
    
    var delegate : ToDoListModelDelegate?
    
    let filterOptions = [
        ItemsFilter.ActiveAndExpired : TimingBasedItemsGrouping(filterStrategy: ActiveAndExpiredItemsFilter()),
        ItemsFilter.ActiveOnly       : TimingBasedItemsGrouping(filterStrategy: ActiveOnlyItemsFilter()),
        ItemsFilter.All              : TimingBasedItemsGrouping(filterStrategy: AllItemsFilter()),
        ItemsFilter.CompletedOnly    : FlatGrouping(filterStrategy: CompletedOnlyItemsFilter())
    ]
    
    private let toDoRepository: ToDoRepository
    
    init(toDoRepository: ToDoRepository) {
        self.toDoRepository = toDoRepository
    }
    
    var toDoList: [String:[ToDoItem]] {
        return self.groupedItems
    }
    
    var toDoCategories: [String] {
        return self.groups
    }
    
    func loadToDoList(filter: ItemsFilter) {
        self.filter = filter
        self.loadToDoList()
    }
    
    func loadToDoList() {
        self.loadToDoListInternal()
        self.delegate?.toDoListChanged(groupedItems: groupedItems!)
    }
    
    func completeToDo(toDo: ToDoItem) {
        if(toDo.status != .done) {
            toDo.completedDate = Date()
            self.toDoRepository.saveItem(item: toDo)
            
            self.applyFilter()
            delegate?.toDoListChanged(groupedItems: groupedItems!)
        }
    }
    
    func undoCompleted(toDo: ToDoItem) {
        if(toDo.status == .done) {
            toDo.completedDate = nil
            self.toDoRepository.saveItem(item: toDo)
            
            self.applyFilter()
            delegate?.toDoListChanged(groupedItems: groupedItems!)
        }
    }
    
    func deleteToDo(toDo: ToDoItem) {
        self.toDoRepository.deleteItem(itemId: toDo.id)
        
        self.loadToDoListInternal()
        delegate?.toDoListChanged(groupedItems: groupedItems!)
    }
    
    private func loadToDoListInternal() {
        self.items = self.toDoRepository.getItems()
        self.applyFilter()

    }
    
    private func applyFilter() {
        self.groupedItems = filterOptions[filter]?.groupItems(items: self.items)
        
        self.groups = [String]()
        for group in GroupingDescriptor.ArrangedGroups {
            if self.groupedItems[group] != nil {
                self.groups.append(group)
            }
        }
        
    }
}
