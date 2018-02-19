//
//  ItemsFilterStrategyTest.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import XCTest

class ItemsFilterStrategyTest: ItemsStartegyTestsBase {
    
    func test_ActiveOnlyFilter() -> Void {
        let filter = ActiveOnlyItemsFilter()
        let filterResult = filter.filterItems(items: self.todoItems)
        
        XCTAssert(filterResult.count == 3)
        XCTAssert(filterResult.filter({ $0.status != .active }).count == 0)
    }
    
    
    func test_ActiveAndExipredFilter() {
        let filter = ActiveAndExpiredItemsFilter()
        let filterResult = filter.filterItems(items: self.todoItems)
        
        XCTAssert(filterResult.count == 5)
        XCTAssert(filterResult.filter({ $0.status != .active && $0.status != .expired }).count == 0)
    }
    
    func test_CompletedOnlyFilter() {
        let filter = CompletedOnlyItemsFilter()
        let filterResult = filter.filterItems(items: self.todoItems)
        
        XCTAssert(filterResult.count == 1)
        XCTAssert(filterResult.filter({ $0.status != .done }).count == 0)
    }
    
    func test_AllFilter() {
        let filter = AllItemsFilter()
        let filterResult = filter.filterItems(items: self.todoItems)
        
        XCTAssert(filterResult.count == todoItems.count)
        XCTAssert(filterResult.filter({ $0.status == .active }).count == 3)
        XCTAssert(filterResult.filter({ $0.status == .expired }).count == 2)
        XCTAssert(filterResult.filter({ $0.status == .done }).count == 1)
    }
    
}
