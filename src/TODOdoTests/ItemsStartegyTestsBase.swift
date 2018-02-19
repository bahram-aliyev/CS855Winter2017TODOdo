//
//  ItemsStartegyTestsBase.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-21.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import XCTest

class ItemsStartegyTestsBase: XCTestCase {

    var todoItems: [ToDoItem] {
        get {
            var items = [ToDoItem]()
            
            items.append(ToDoItem("ValiImmediate", timing: .immediate, priority: .medium))
            items.append(ToDoItem("ValidDueDate", timing: .dueDate(Date()), priority: .medium))
            items.append(ToDoItem("Unspecified", timing: .unspecified, priority: .medium))
            
            let expiredDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            
            let expiredImmediate = ToDoItem("ExpiredImmediate", timing: .immediate, priority: .high)
            expiredImmediate.entryDate = expiredDate
            items.append(expiredImmediate)
            
            items.append(ToDoItem("ExpiredDueDate", timing: .dueDate(expiredDate), priority: .high))
            
            let unspecifiedDoneItem = ToDoItem("UnspecifiedDone", timing: .unspecified, priority: .high)
            unspecifiedDoneItem.completedDate = Date()
            items.append(unspecifiedDoneItem)
            
            
            return items
        }
    }

}
