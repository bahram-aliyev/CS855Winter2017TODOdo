//
//  TodoEntry.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ToDoEntryModel {
    
    var delegate: ToDoEntryModelDelegate?
    private(set) var current: ToDoItem!
    private(set) var isNew:Bool!
    
    private let toDoRepository: ToDoRepository
    
    init(toDoRepository : ToDoRepository) {
        self.toDoRepository = toDoRepository
    }
    
    func newToDo() {
        self.current = ToDoItem.init("", timing: .unspecified , priority: .medium)
        self.isNew = true
        self.delegate?.toDoReadyForEntry(toDo: self.current)
    }
    
    func loadToDo(toDoId: String) {
        let found = toDoRepository.getItem(itemId: toDoId)!
        self.current =
                ToDoItem(id: found.id, title: found.title, notes: found.notes,
                            imageThumbnail: found.imageThumbnail, entryDate: found.entryDate,
                                timing: found.timing, priority: found.priority, completedDate: found.completedDate)
        self.isNew = false
        self.delegate?.toDoReadyForEntry(toDo: self.current)
    }
    
    func saveToDo() {
        self.toDoRepository.saveItem(item: self.current)
    }
    
    func cancelToDo() {
        let cancelledToDo = self.current
        self.current = nil
        self.delegate?.toDoCancelled(toDo: cancelledToDo!)
    }
    
}
