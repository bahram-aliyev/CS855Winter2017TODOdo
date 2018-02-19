//
//  ToDoEntryModelTests.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-22.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import XCTest

class ToDoEntryModelTests: ToDoRepositoryDependantTestsBase,
    ToDoEntryModelDelegate {
    
    var readyForEntryCalled = 0
    var toDoCancelledCalled = 0
    
    var toDoEntryModel: ToDoEntryModel!
    
    override func setUp() {
        super.setUp()
        
        self.toDoEntryModel = ToDoEntryModel(toDoRepository: self)
        self.toDoEntryModel.delegate = self
        
        self.readyForEntryCalled = 0
        self.toDoCancelledCalled = 0
    }
    
    func test_newTodo_CheckSequence() {
        toDoEntryModel.newToDo()
        
        XCTAssertNotNil(toDoEntryModel.current)
        XCTAssertEqual(self.readyForEntryCalled, 1)
        XCTAssertEqual(self.operationCounter, self.readyForEntryCalled)
    }
    
    func test_loadToDo_CheckSequence() {
        let toDoId = UUID().uuidString
        
        toDoEntryModel.loadToDo(toDoId: toDoId)
        
        XCTAssertNotNil(toDoEntryModel.current)
        XCTAssertEqual(toDoEntryModel.current.id, toDoId)
        XCTAssertEqual(self.getItemCalled, 1)
        XCTAssertEqual(self.readyForEntryCalled, 2)
        XCTAssertEqual(self.operationCounter, self.readyForEntryCalled)
    }
    
    func test_saveToDo_CheckSequence() {
        toDoEntryModel.newToDo()
        self.toDoEntryModel.saveToDo()
        
        XCTAssertEqual(self.readyForEntryCalled, 1)
        XCTAssertEqual(self.saveItemCalled, 2)
        XCTAssertEqual(self.operationCounter, self.saveItemCalled)
    }
    
    func test_cancelToDo_CheckSequence() {
        toDoEntryModel.newToDo()
        toDoEntryModel.cancelToDo()
        
        XCTAssertNil(toDoEntryModel.current)
        XCTAssertEqual(self.saveItemCalled, 0)
        XCTAssertEqual(self.readyForEntryCalled, 1)
        XCTAssertEqual(self.toDoCancelledCalled, 2)
        XCTAssertEqual(self.operationCounter, self.toDoCancelledCalled)
    }
    
    // MARK: ToDoEntryModelDelegate
    
    func toDoReadyForEntry(toDo: ToDoItem) {
        readyForEntryCalled = self.incrementOperationCounter()
    }
    
    func toDoCancelled(toDo: ToDoItem) {
        self.itemId = toDo.id
        toDoCancelledCalled = self.incrementOperationCounter()
    }
}
