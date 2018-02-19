//
//  TodoEntryDelegate.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ToDoEntryModelDelegate {
    func toDoReadyForEntry(toDo: ToDoItem)
    func toDoCancelled(toDo: ToDoItem)
}
