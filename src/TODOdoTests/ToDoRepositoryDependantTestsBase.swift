//
//  ToDoRepositoryDependantTestsBase.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-22.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import XCTest

class ToDoRepositoryDependantTestsBase: XCTestCase, ToDoRepository {
    
    private(set) var operationCounter = 0
    
    private(set) var getItemsCalled = 0
    private(set) var deleteItemCalled = 0
    private(set) var saveItemCalled = 0
    private(set) var getItemCalled = 0
    
    var itemId = ""
    
    override func setUp() {
        super.setUp()
        
        self.operationCounter = 0
        
        self.getItemsCalled = 0
        self.deleteItemCalled = 0
        self.saveItemCalled = 0
    }
    
    // MARK: ToDoRepository
    
    func getItems() -> [ToDoItem] {
        self.getItemsCalled = self.incrementOperationCounter()
        return [ToDoItem.init("TestItem", timing: .immediate, priority: .high)]
    }
    
    func getItem(itemId: String) -> ToDoItem? {
        self.getItemCalled = self.incrementOperationCounter()
        self.itemId = itemId
        
        return ToDoItem.init(
            id: itemId, title: "", notes: "", imageThumbnail: nil,
            entryDate: Date(), timing: .unspecified,
            priority: .medium, completedDate: nil
        )
    }
    
    func deleteItem(itemId: String) {
        self.deleteItemCalled = self.incrementOperationCounter()
        self.itemId = itemId
    }
    
    func saveItem(item: ToDoItem) {
        self.saveItemCalled = self.incrementOperationCounter()
        self.itemId = item.id
    }
    
    func incrementOperationCounter() -> Int {
        self.operationCounter += 1
        return self.operationCounter
    }

}
