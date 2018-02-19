//
//  InMemoryToDoRepository.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-24.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import os.log

class InMemoryToDoRepository : ToDoRepository {
    
    private static var _toDoItems: [ToDoItem]!
    
    static let ToDoItemsUrlPath = FileManager()
                    .urls(for: .documentDirectory, in: .userDomainMask)
                        .first!.appendingPathComponent("ToDoItemsData").path
    
    private var toDoItems : [ToDoItem]! {
        get {
            return InMemoryToDoRepository._toDoItems
        }
        set {
            InMemoryToDoRepository._toDoItems = newValue
        }
    }
    
    init() {
        self.loadToDoItems()
    }
    
    func deleteItem(itemId: String) {
        if let index = getItemIndexById(itemId) {
            self.toDoItems.remove(at: index)
            self.saveToDoItems()
        }
    }
    
    func getItem(itemId: String) -> ToDoItem? {
        if let index = getItemIndexById(itemId) {
            return self.toDoItems[index]
        }
        
        return nil
    }
    
    func saveItem(item: ToDoItem) {
        if let index = getItemIndexById(item.id) {
            self.toDoItems[index] = item
        }
        else {
            self.toDoItems.append(item)
        }
        
        self.saveToDoItems()
    }
    
    func getItems() -> [ToDoItem] {
        return self.toDoItems
    }
    
    private func getItemIndexById(_ id: String) -> Int? {
        return self.toDoItems.index { $0.id == id }
    }
    
    private func saveToDoItems() {
        var itemsDto: [ToDoItemDto] = [ToDoItemDto]()
        for toDo in InMemoryToDoRepository._toDoItems {
            itemsDto.append(ToDoItemDto(toDo))
        }
        
        let isSuccessfulSave =
                NSKeyedArchiver.archiveRootObject(itemsDto, toFile: InMemoryToDoRepository.ToDoItemsUrlPath)
        
        if isSuccessfulSave {
            os_log("ToDo items successfully saved.", log: .default, type: .debug)
        }
        else {
            os_log("Failed to save ToDo items!", log: .default, type: .debug)
        }
    }
    
    private func loadToDoItems() {
        if InMemoryToDoRepository._toDoItems != nil { return }
        
        var toDoItems: [ToDoItem] = [ToDoItem]()
        
        let path = InMemoryToDoRepository.ToDoItemsUrlPath
        let toDoDtoItems = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [ToDoItemDto]
        
        if toDoDtoItems != nil {
            toDoItems = [ToDoItem]()
                
            for toDoDto in toDoDtoItems! {
                toDoItems.append(toDoDto.toToDoItem())
            }
        }
        else {
            toDoItems = self.loadIntroData()
        }
        
        InMemoryToDoRepository._toDoItems = toDoItems
    }
    
    private func loadIntroData() -> [ToDoItem] {
        var fakeToDoList = [ToDoItem]()
        fakeToDoList.append(ToDoItem.init("That's how a 'Due Date' ToDo looks like", timing: .dueDate(Date()), priority: .high))
        fakeToDoList.append(ToDoItem.init("That's how an 'Immediate' ToDo looks like", timing: .immediate, priority: .medium))
        fakeToDoList.append(ToDoItem.init("Press the top left action to change the ToDos' filter", timing: .immediate, priority: .high))
        fakeToDoList.append(ToDoItem.init("Just a medium priority task (orange sticker)", timing: .unspecified, priority: .medium))
        fakeToDoList.append(ToDoItem.init("Just a low priority task (blue sticker)", timing: .unspecified, priority: .low))
        
        let expDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        fakeToDoList.append(ToDoItem.init("Expired ToDo with a high priority (red sticker)", timing: .dueDate(expDate), priority: .high))
        
        let doneToDo = ToDoItem.init("This ToDo is completed, delete or undo it by swiping from right to left.", timing: .dueDate(Date()), priority: .medium)
        doneToDo.completedDate = Date()
        fakeToDoList.append(doneToDo)
        
        return fakeToDoList
    }
}
