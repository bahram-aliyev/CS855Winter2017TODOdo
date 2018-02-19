//
//  TodoListDelegate.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ToDoListModelDelegate {
    func toDoListChanged(groupedItems: [String:[ToDoItem]])
}
