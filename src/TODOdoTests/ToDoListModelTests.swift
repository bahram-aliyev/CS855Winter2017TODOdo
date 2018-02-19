//
//  ToDoListTests.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import XCTest

class ToDoListModelTests: ToDoRepositoryDependantTestsBase, ToDoListModelDelegate {
    
    var toDoListModel: ToDoListModel!
    
    var toDoListChangedCalled = 0
    
    private var loadedItem: ToDoItem!
    
    override func setUp() {
        super.setUp()
        
        self.toDoListChangedCalled = 0
        self.toDoListModel = ToDoListModel(toDoRepository: self)
        self.toDoListModel.delegate = self
        self.toDoListModel.loadToDoList()
        self.itemId = ""
    }
    
    func test_loadToDoList_CheckSequence() {
        XCTAssertEqual(self.getItemsCalled, 1)
        XCTAssertEqual(self.toDoListChangedCalled, 2)
        XCTAssertEqual(self.operationCounter, 2)
    }
    
    func test_completeToDo_uncompleteItem_CheckSequence() {
        let todoItem = ToDoItem.init("TestItem", timing: .immediate, priority: .high)
        self.toDoListModel.completeToDo(toDo: todoItem)
        
        XCTAssertEqual(self.saveItemCalled, 3)
        XCTAssertEqual(self.toDoListChangedCalled, 4)
        XCTAssertEqual(self.operationCounter, self.toDoListChangedCalled)
        XCTAssertEqual(self.itemId, todoItem.id)
    }
    
    func test_completeToDo_completeItem_CheckSequence() {
        self.toDoListModel.completeToDo(toDo: self.loadedItem)
        
        XCTAssertEqual(self.saveItemCalled, 3)
        XCTAssertEqual(self.toDoListChangedCalled, 4)
        XCTAssertEqual(self.operationCounter, self.toDoListChangedCalled)
        XCTAssertEqual(self.itemId, self.loadedItem.id)
    }
    
    func test_deleteTodo_CheckSequence() {
        self.toDoListModel.deleteToDo(toDo: self.loadedItem)
        
        XCTAssertEqual(self.deleteItemCalled, 3)
        XCTAssertEqual(self.getItemsCalled, 4)
        XCTAssertEqual(self.toDoListChangedCalled, 5)
        XCTAssertEqual(self.operationCounter, self.toDoListChangedCalled)
    }
    
    func test_undoCompleted_CheckSequence() {
        let todoItem = ToDoItem.init("TestItem", timing: .immediate, priority: .high)
        todoItem.completedDate = Date()
        
        self.toDoListModel.undoCompleted(toDo: todoItem)
        
        XCTAssertEqual(self.saveItemCalled, 3)
        XCTAssertEqual(self.toDoListChangedCalled, 4)
        XCTAssertEqual(self.operationCounter, self.toDoListChangedCalled)
        XCTAssertEqual(todoItem.id, self.itemId)
    }
    
    func test_undoUncompleted_CheckSequence() {
        let todoItem = ToDoItem.init("TestItem", timing: .immediate, priority: .high)
        todoItem.completedDate = Date()
        
        self.toDoListModel.undoCompleted(toDo: todoItem)
        
        XCTAssertEqual(self.saveItemCalled, 3)
        XCTAssertEqual(self.toDoListChangedCalled, 4)
        XCTAssertEqual(self.operationCounter, self.toDoListChangedCalled)
        XCTAssertEqual(todoItem.id, self.itemId)
    }
    
    // MARK: ToDoListDelegate
    
    func toDoListChanged(groupedItems: [String:[ToDoItem]]) {
        self.toDoListChangedCalled = self.incrementOperationCounter()
        self.loadedItem = groupedItems.first?.value.first
    }
    
}
