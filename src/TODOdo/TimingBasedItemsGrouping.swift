//
//  TimingBasedItemsGrouping.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-21.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class TimingBasedItemsGrouping : ItemsGroupingStrategy {
    
    override func groupItems(items: [ToDoItem]) -> [String : [ToDoItem]] {
        var groupedItems = groupItemsInternal(self.filterStrategy.filterItems(items: items))
        
        groupedItems[GroupingDescriptor.Immediate]?
            .sort(by: sortItemsByPriorityTemplate(secondarySortTemplate: sortByDueDateDesc))
        
        groupedItems[GroupingDescriptor.DueDate]?
            .sort(by: sortItemsByPriorityTemplate(secondarySortTemplate: sortByDueDateDesc))
        
        groupedItems[GroupingDescriptor.Unspecified]?.sort(
                by: sortItemsByPriorityTemplate(secondarySortTemplate: {
                    (item1:ToDoItem, item2:ToDoItem) -> Bool in self.sortByDateDesc(item1.entryDate, item2.entryDate)
                }))
        
        return groupedItems;
    }
    
    func groupItemsInternal(_ items: [ToDoItem]) -> [String : [ToDoItem]] {
        var groupedItems = [String : [ToDoItem]]()
        
        for item in items {
            var groupingDesc :  String
            
            switch item.timing {
                case .dueDate(_):
                    groupingDesc = GroupingDescriptor.DueDate
                case .immediate:
                    groupingDesc = GroupingDescriptor.Immediate
                default:
                    groupingDesc = GroupingDescriptor.Unspecified
            }
            
            if groupedItems[groupingDesc] == nil {
                groupedItems[groupingDesc] = [ToDoItem]()
            }
            
            groupedItems[groupingDesc]!.append(item)
        }
        
        return groupedItems
    }
    
    func sortItemsByPriorityTemplate(secondarySortTemplate:@escaping (ToDoItem, ToDoItem) -> Bool) ->
        (ToDoItem, ToDoItem) -> Bool {
            return {
                (item1: ToDoItem, item2: ToDoItem) -> Bool in
                    let item1Priority = item1.priority.rawValue
                    let item2Priority = item2.priority.rawValue
            
                    return item1Priority != item2Priority
                                ? (item1Priority > item2Priority)
                                : secondarySortTemplate(item1, item2)
            }
    }
    
    func sortByDueDateDesc(todoItem1: ToDoItem, todoItem2: ToDoItem) -> Bool {
        return sortByDateDesc(todoItem1.dueDate, todoItem2.dueDate)
    }
}
