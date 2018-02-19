//
//  ItemsGroupingStrategyTests.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-21.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import XCTest

class ItemsGroupingStrategyTests: ItemsStartegyTestsBase {
    
    func test_TimingBasedItemsGrouping_GroupingCheck() {
        let timingBasedGrouping = TimingBasedItemsGrouping(filterStrategy: AllItemsFilter())
        let groupingResult = timingBasedGrouping.groupItems(items: self.todoItems)
        
        XCTAssert(groupingResult.keys.count == 3)
        
        XCTAssert(groupingResult[GroupingDescriptor.DueDate]?.count == 2)
        
        XCTAssert(groupingResult[GroupingDescriptor.Immediate]?.count == 2)
        XCTAssert(groupingResult[GroupingDescriptor.Unspecified]?.count == 2)
    }
    
    func test_TimingBasedGrouping_ItemsPriorityOrderCheck() {
        let timingBasedGrouping = TimingBasedItemsGrouping(filterStrategy: AllItemsFilter())
        let groupingResult = timingBasedGrouping.groupItems(items: self.todoItems)
        
        XCTAssertFalse(isOrderedByTemplate(todoItems, checkPriorityOrder))
        
        XCTAssert(isOrderedByTemplate(groupingResult[GroupingDescriptor.DueDate]!, checkPriorityOrder))
        XCTAssert(isOrderedByTemplate(groupingResult[GroupingDescriptor.Immediate]!, checkPriorityOrder))
        XCTAssert(isOrderedByTemplate(groupingResult[GroupingDescriptor.Unspecified]!, checkPriorityOrder))
    }
    
    func test_TimingBasedGrouping_ItemsDueDateOrderCheck() {
        
        var priorityTodoItems = [ToDoItem]()
        let dueDatePlus = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let dueDateMinus = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        priorityTodoItems +=
        [
            ToDoItem("High1", timing: .dueDate(Date()), priority: .high),
            ToDoItem("High2", timing: .dueDate(dueDatePlus), priority: .high),
            ToDoItem("High3", timing: .dueDate(dueDateMinus), priority: .high),
            
            ToDoItem("Medium1", timing: .dueDate(Date()), priority: .medium),
            ToDoItem("Medium3", timing: .dueDate(dueDateMinus), priority: .medium),
            ToDoItem("Medium2", timing: .dueDate(dueDatePlus), priority: .medium),
        ]
        
        let timingBasedGrouping = TimingBasedItemsGrouping(filterStrategy: AllItemsFilter())
        let groupingResult = timingBasedGrouping.groupItems(items: priorityTodoItems)
        
        let highPrItems = groupingResult[GroupingDescriptor.DueDate]!.filter { $0.priority == .high }
        let mediumPrItems = groupingResult[GroupingDescriptor.DueDate]!.filter { $0.priority == .medium }
        
        XCTAssertFalse(isOrderedByTemplate(priorityTodoItems, checkDueDateOrder))
        XCTAssert(isOrderedByTemplate(highPrItems, checkDueDateOrder))
        XCTAssert(isOrderedByTemplate(mediumPrItems, checkDueDateOrder))
    }
    
    func test_FlatGroupingTest_CompletedItemsEndDateOrderCheck() {
        
        let flatGrouping = FlatGrouping(filterStrategy: CompletedOnlyItemsFilter())
        var flatTodoItems = [ToDoItem]()
        
        let completedItem1 = ToDoItem.init("Completed1", timing: .unspecified, priority: .high)
        completedItem1.completedDate = Date()
        
        let completedItem2 = ToDoItem.init("Completed2", timing: .unspecified, priority: .low)
        completedItem2.completedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let completedItem3 = ToDoItem.init("Completed3", timing: .unspecified, priority: .medium)
        completedItem3.completedDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        flatTodoItems += [completedItem1, completedItem2, completedItem3]
        let groupingResult = flatGrouping.groupItems(items: flatTodoItems)
        
        XCTAssertFalse(isOrderedByTemplate(flatTodoItems, checkCompleteDateOrder))
        
        XCTAssert(groupingResult[GroupingDescriptor.Completed]!.count == flatTodoItems.count)
        XCTAssert(groupingResult.keys.count == 1)
        XCTAssert(isOrderedByTemplate(groupingResult[GroupingDescriptor.Completed]!, checkCompleteDateOrder))
    }
    
    // MARK: Utility Methods
    
    private func isOrderedByTemplate(_ items: [ToDoItem], _ checkOrder: (ToDoItem, ToDoItem) -> Bool) -> Bool {
        var current = items.first
        for itm in items {
            if !checkOrder(current!, itm) { return false }
            current = itm
        }
        
        return true
    }
    
    private func checkPriorityOrder(_ current: ToDoItem, _ next: ToDoItem) -> Bool {
        return current.priority.rawValue >= next.priority.rawValue
    }
    
    private func checkDueDateOrder(_ current: ToDoItem, _ next: ToDoItem) -> Bool {
        return current.dueDate! >= next.dueDate!
    }
    
    private func checkCompleteDateOrder(_ current: ToDoItem, _ next: ToDoItem) -> Bool {
        return current.completedDate! >= next.completedDate!
    }

}
