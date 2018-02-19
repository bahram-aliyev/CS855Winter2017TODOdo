//
//  TodoRepository.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

public protocol ToDoRepository {
    func getItems() -> [ToDoItem]
    func getItem(itemId: String) -> ToDoItem?
    func saveItem(item: ToDoItem)
    func deleteItem(itemId: String)
}
