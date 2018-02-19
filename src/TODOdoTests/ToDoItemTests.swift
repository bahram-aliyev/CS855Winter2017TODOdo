//
//  TodoItemTests.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import XCTest
@testable import TODOdo

class ToDoItemTests: XCTestCase {
    
    private var todoItem: ToDoItem!
    
    override func setUp() {
        super.setUp()
        self.todoItem = ToDoItem("TestItem", timing: .unspecified, priority: .high)
    }
    
    func test_DefaultItemsIsActive() {
        XCTAssert(self.todoItem.status == .active)
    }
    
    func test_CompletedItemsIsDone() {
        self.todoItem.completedDate = Date()
        XCTAssert(self.todoItem.status == .done)
    }
    
    func test_ImediateItemIsActive() {
        self.todoItem.timing = .immediate
        XCTAssert(self.todoItem.status == .active)
    }
    
    func test_DueDateTodayItemIsActive() {
        self.todoItem.timing = .dueDate(Date())
        XCTAssert(self.todoItem.status == .active)
    }
    
    func test_DueDateTommorowItemIsActive() {
        let dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        self.todoItem.timing = .dueDate(dueDate!)
        XCTAssert(self.todoItem.status == .active)
    }
    
    func test_DueDateYesterdayItemIsExpired() {
        let dueDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        self.todoItem.timing = .dueDate(dueDate!)
        XCTAssert(self.todoItem.status == .expired)
    }
    
    func test_ImmediateTimingForYesterdaysEntryIsExpired() {
        self.todoItem.entryDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        self.todoItem.timing = .immediate
        XCTAssert(self.todoItem.status == .expired)

    }
    
}
